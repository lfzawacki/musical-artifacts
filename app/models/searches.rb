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

  def self.artifacts_by_metadata artifacts, terms
    if terms.present?
      artifacts = artifacts.where('name ILIKE ? OR description ILIKE ?', "%#{terms}%", "%#{terms}%")
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
      licenses = License.where(short_name: split_terms(terms))
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
