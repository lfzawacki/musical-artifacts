#
# Multiple coupled search methods for the application
#

class Searches
  def self.max_taggings_on_search
    10
  end

  def self.tags terms
    query = ActsAsTaggableOn::Tag.includes(:taggings).where(taggings: {context: 'tags'})

    query = query.named_like(terms) if terms.present?
    query
  end

  def self.recent_tags number
    self.tags('').order('created_at DESC').last(number)
  end

  def self.app_tags terms
    query = ActsAsTaggableOn::Tag.includes(:taggings).where(taggings: {context: 'software'})

    query = query.named_like(terms) if terms.present?
    query
  end

  def self.file_format_tags terms
    query = ActsAsTaggableOn::Tag.includes(:taggings).where(taggings: {context: 'file_formats'})

    query = query.named_like(terms) if terms.present?
    query
  end

  def self.artifacts_tagged_with artifacts, terms
    if terms.present?
      terms = split_terms(terms).first(max_taggings_on_search)
      artifacts = artifacts.tagged_with(terms, on: 'tags')
    end
    artifacts
  end

  def self.artifacts_app_tagged_with artifacts, terms
    if terms.present?
      terms = split_terms(terms).first(max_taggings_on_search)
      artifacts = artifacts.tagged_with(terms, on: 'software')
    end
    artifacts
  end

  def self.artifacts_licensed_as scope, term
    if term.present?
      scope = Searches.new(scope, :license => term).call
    end
    scope
  end

  def self.artifacts_with_hash artifacts, hash
    if hash.present?
      artifacts = artifacts.where(file_hash: hash)
    end
    artifacts
  end

  def self.artifacts_with_file_format artifacts, format
    if format.present?
      artifacts = artifacts.tagged_with(format, on: 'file_formats')
    end
    artifacts
  end

  def self.artifacts_by_metadata scope, terms
    if terms.present?
      scope = Searches.new(scope, :q => terms).call
    end
    scope
  end

  def initialize(scope = Artifact.all, params = {})
    @scope = scope
    @params = params
    @tag_conditions = {}
  end

  def call
    by_hash
    collect_tag_conditions
    apply_tag_filters
    by_license
    by_metadata

    @scope
  end

  private
  def by_hash
    return unless @params[:hash].present?
    @scope = @scope.where(file_hash: @params[:hash])
  end

  def collect_tag_conditions
    @tag_conditions['tags'] = @params[:tags] if @params[:tags].present?
    @tag_conditions['software'] = @params[:apps] if @params[:apps].present?
    @tag_conditions['file_formats'] = @params[:formats] if @params[:formats].present?
  end

  def apply_tag_filters
    return if @tag_conditions.empty?

    valid_contexts = ['tags', 'software', 'file_formats']
    context_terms = {}

    @tag_conditions.each do |context, raw|
      next unless valid_contexts.include?(context)
      context_terms[context] = Searches.split_terms(raw).first(self.class.max_taggings_on_search)
    end

    return if context_terms.empty?

    where_parts = context_terms.map do |context, terms|
      escaped = terms.map(&:downcase).map { |t| ActiveRecord::Base.connection.quote(t) }.join(',')
      "(t.context = '#{context}' AND LOWER(tags.name) IN (#{escaped}))"
    end

    having_parts = context_terms.keys.map do |context|
      "COUNT(CASE WHEN t.context = '#{context}' THEN 1 END) > 0"
    end

    join_sql = <<~SQL.squish
      INNER JOIN (
        SELECT t.taggable_id
        FROM taggings t
        JOIN tags ON tags.id = t.tag_id
        WHERE t.taggable_type = 'Artifact'
          AND (#{where_parts.join(' OR ')})
        GROUP BY t.taggable_id
        HAVING #{having_parts.join(' AND ')}
      ) AS tag_filters ON tag_filters.taggable_id = artifacts.id
    SQL

    @scope = @scope.joins(join_sql)
  end

  def by_license
    return unless @params[:license].present?
    term = @params[:license]

    if term == 'free'
      licenses = License.where(free: true)
    else
      # search by short_name and license_type, e.g.
      # 'by' for CC Attribution and 'cc' for all CC licenses
      licenses = License.where(short_name: term).union(License.where(license_type: term))
    end

    @scope = @scope.where(license: licenses)
  end

  def by_metadata
    return unless @params[:q].present?
    terms = @params[:q]
    tag_terms = Searches.split_terms(terms).first(self.class.max_taggings_on_search)

    sanitized_terms = terms.split(/\s+/).map { |t| sanitize_tsquery_term(t) }.reject(&:empty?)
    return if sanitized_terms.empty?

    tsquery = sanitized_terms.map { |t| "#{t}:*" }.join(' & ')

    text_clause = "to_tsvector('english', coalesce(name, '') || ' ' || coalesce(description, '') || ' ' || coalesce(author, '') || ' ' || coalesce(extra_license_text, '')) @@ to_tsquery('english', :tsquery)"

    if tag_terms.any?
      tag_clause = [
        tag_exists_sql('tags', tag_terms)[0],
        tag_exists_sql('software', tag_terms)[0],
        tag_exists_sql('file_formats', tag_terms)[0]
      ].join(' OR ')

      @scope = @scope.where(
        "(#{text_clause}) OR (#{tag_clause})",
        tsquery: tsquery,
        terms: tag_terms.map(&:downcase)
      )
    else
      @scope = @scope.where(text_clause, tsquery: tsquery)
    end
  end

  def sanitize_tsquery_term(term)
    term.gsub(/[^[:alnum:]]/, '')
  end

  # Split ignoring spaces and properly handling URL encoding
  def self.split_terms terms
    CGI.unescape(terms.to_s).split(/\s*,\s*/)
  end

  def tag_exists_sql(context, terms)
    valid_contexts = ['tags', 'software', 'file_formats']
    raise ArgumentError, "Invalid context" unless valid_contexts.include?(context)

    sql = <<~SQL
      EXISTS (
        SELECT 1
        FROM taggings t
        JOIN tags ON tags.id = t.tag_id
        WHERE t.taggable_type = 'Artifact'
          AND t.taggable_id = artifacts.id
          AND t.context = '#{context}'
          AND LOWER(tags.name) IN (:terms)
      )
    SQL

    [sql, { terms: terms.map(&:downcase) }]
  end
end
