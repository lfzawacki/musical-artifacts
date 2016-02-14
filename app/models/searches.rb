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
      artifacts = artifacts.tagged_with(split_terms(terms), on: 'tags')
    end
    artifacts
  end

  def self.artifacts_app_tagged_with artifacts, terms
    if terms.present?
      artifacts = artifacts.tagged_with(split_terms(terms), on: 'software')
    end
    artifacts
  end

  def self.artifacts_licensed_as artifacts, terms
    if terms.present?
      all_terms = split_terms(terms)

      if all_terms.include? 'free'
        licenses = License.where(free: true)
      else
        # search by short_name and license_type, e.g.
        # 'by' for CC Attribution and 'cc' for all CC licenses
        licenses = License.where(short_name: all_terms)
        licenses = licenses.union(License.where(license_type: all_terms))
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

  def self.artifacts_with_file_format artifacts, formats
    if formats.present?
      with_format = Artifact.none

      split_terms(formats).each do |term|
        with_format = with_format.union(artifacts.tagged_with(term, on: 'file_formats'))
      end

      artifacts = with_format
    end
    artifacts
  end


  private
  # Split ignoring spaces and unescape ' ' and ','
  def self.split_terms terms
    terms.gsub('%20',' ').gsub('%2C', ',').split(/\s*,\s*/)
  end
end
