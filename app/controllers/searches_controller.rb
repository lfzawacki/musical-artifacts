class SearchesController < ApplicationController

  respond_to :json

  def tags
    query = params[:q] || ''
    @tags = ActsAsTaggableOn::Tag.named_like(query)
  end

  def software
    query = params[:q] || ''
    @software = ActsAsTaggableOn::Tag.named_like(query)
  end

end
