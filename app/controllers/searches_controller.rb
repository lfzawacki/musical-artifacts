class SearchesController < ApplicationController

  respond_to :json

  def tags
    @tags = Searches.tags(params[:q])
  end

  def software
    @software = Searches.app_tags(params[:q])
  end

end
