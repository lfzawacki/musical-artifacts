class InfoController < ApplicationController

  def about
    @tags = Artifact.tag_counts.order('taggings_count DESC').pluck(:name).first(8)

    render layout: false
  end
end
