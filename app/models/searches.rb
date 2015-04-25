#
# Multiple coupled search methods for the application
#

class Searches
  def self.tags terms
    query = ActsAsTaggableOn::Tag.includes(:taggings).where(taggings: {context: 'tags'})

    query = query.named_like(terms) if terms.present?
    query
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
      artifacts = artifacts.tagged_with(terms.split(','), on: 'tags')
    end
    artifacts
  end

  def self.artifacts_app_tagged_with artifacts, terms
    if terms.present?
      artifacts = artifacts.tagged_with(terms.split(','), on: 'software')
    end
    artifacts
  end

  def self.artifacts_licensed_as artifacts, terms
    artifacts
  end

  def self.artifacts_with_hash artifacts, hash
    Artifact.where(file_hash: hash)
  end
end
