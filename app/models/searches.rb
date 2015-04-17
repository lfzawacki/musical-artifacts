#
# Multiple coupled search methods for the application
#

class Searches
  def self.artifacts_by_tag terms
    query = ActsAsTaggableOn::Tag.includes(:taggings).where(taggings: {context: 'tags'})

    query = query.named_like(terms) if terms.present?
    query
  end

  def self.artifacts_by_software terms
    query = ActsAsTaggableOn::Tag.includes(:taggings).where(taggings: {context: 'software'})

    query = query.named_like(terms) if terms.present?
    query
  end

  def self.artifacts_by_metadata terms
    art = Artifact.all

    if terms.present?
      art = art.where('name ILIKE ? OR description ILIKE ?', "%#{terms}%", "%#{terms}%")
    end
    art
  end

  # def 

end
