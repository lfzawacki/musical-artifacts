class InfoController < ApplicationController

  def about
    @tags = Artifact.tag_counts.order('taggings_count DESC').pluck(:name).first(16)
  end

  def contact
  end

  def optout
  end

  def survey
  end

  def terms_and_conditions
  end

end
