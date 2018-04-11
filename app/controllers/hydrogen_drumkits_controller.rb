# This controller implements a xml backend that returns a
# drumkit list in a format Hydrogen can read

# XML spec is taken from:
# https://github.com/hydrogen-music/hydrogen/wiki/Soundlibrary-download-feature
class HydrogenDrumkitsController < InheritedResources::Base

  rescue_from ActionController::UnknownFormat, with: :remove_trailing_whitespaces

  before_filter only: [:index] do
    load_artifacts
    filter_licenses
  end

  def index
    render_drumkits
  end

  private

  def load_artifacts
    # Hydrogen artifacts with a file of .h2drumkit format
    @artifacts = Searches.artifacts_app_tagged_with(Artifact, 'hydrogen')
  end

  def filter_licenses
    if params[:free].present? || params[:license] == 'free'
      @artifacts = Searches.artifacts_licensed_as(@artifacts, 'free')
    end
  end

  def render_drumkits
    @drumkits, @songs, @patterns = ['h2drumkit', 'h2song', 'h2pattern'].map do |format|
      Searches.artifacts_with_file_format(@artifacts, format).order('name ASC').includes(:license)
    end

    @hydrogen = {drumkit: @drumkits, pattern: @patterns, song: @songs}

    respond_to do |format|
      format.xml
    end
  end

  # It's common for users to include trailing whitespaces in the URL and this will cause server errors
  # because xml%20 is an invalid format. This tries to get back from this error
  def remove_trailing_whitespaces exception
    if params[:format].try(:match, /xml\s+/)
      request.format = :xml
      render_drumkits
    else
      raise exception
    end
  end
end

