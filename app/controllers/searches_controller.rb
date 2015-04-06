class SearchesController < ApplicationController

  respond_to :json

  def tags
    @tags = ActsAsTaggableOn::Tag.includes(:taggings).where(taggings: {context: 'tags'})

    if params[:q]
      @tags = @tags.named_like(params[:q])
    end
  end

  def software
    @software = ActsAsTaggableOn::Tag.includes(:taggings).where(taggings: {context: 'software'})

    if params[:q]
      @software = @software.named_like(params[:q])
    end
  end

end
