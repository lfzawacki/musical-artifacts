#
# Multiple coupled search methods for the application
#

class Searches
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

  # The main search in the website. Looks into name, description, author and license text
  # It will also match artifacts tagged, app_tagged of with a file format if it exactly
  # matches the searched terms, e.g., 'guitar', 'zip', 'guitarix'
  def self.artifacts_by_metadata artifacts, terms
    if terms.present?
      search_by_data =
        artifacts.where('name ILIKE ? OR description ILIKE ? OR author ILIKE ? OR extra_license_text ILIKE ?',
        "%#{terms}%", "%#{terms}%", "%#{terms}%", "%#{terms}%")

      search_by_data = search_by_data.union(artifacts_tagged_with(artifacts, terms))
      search_by_data = search_by_data.union(artifacts_app_tagged_with(artifacts, terms))
      artifacts = search_by_data.union(artifacts_with_file_format(artifacts, terms))
    end
    artifacts
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

  def self.artifacts_licensed_as artifacts, term
    if term.present?
      if term == 'free'
        licenses = License.where(free: true)
      else
        # search by short_name and license_type, e.g.
        # 'by' for CC Attribution and 'cc' for all CC licenses
        licenses = License.where(short_name: term)
        licenses = licenses.union(License.where(license_type: term))
      end

      artifacts = artifacts.where(license: licenses)
    end
    artifacts
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


  private
  # Split ignoring spaces
  def self.split_terms terms
    terms.split(/\s*,\s*/)
  end

  def self.max_taggings_on_search
    10
  end
end
