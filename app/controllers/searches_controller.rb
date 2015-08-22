class SearchesController < ApplicationController

  respond_to :json

  def tags
    @tags = Searches.tags(params[:q])
  end

  def software
    @software = Searches.app_tags(params[:q])
  end

  def file_formats
    @file_formats = Searches.file_format_tags(params[:q])
  end

end
