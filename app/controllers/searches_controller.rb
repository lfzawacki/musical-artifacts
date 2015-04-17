class SearchesController < ApplicationController

  respond_to :json

  def tags
    @tags = Searches.artifacts_by_tags(params[:q])
  end

  def software
    @software = Searches.artifacts_by_software(params[:q])
  end

end
