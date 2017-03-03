# This controller implements a xml backend that returns a
# drumkit list in a format Hydrogen can read

# XML spec is taken from:
# https://github.com/hydrogen-music/hydrogen/wiki/Soundlibrary-download-feature
class HydrogenDrumkitsController < InheritedResources::Base

  rescue_from ActionController::UnknownFormat, with: :remove_trailing_whitespaces

  def index
    render_drumkits
  end

  private

  def render_drumkits
    # Hydrogen artifacts with a file of .h2drumkit format
    artifacts = Searches.artifacts_app_tagged_with(Artifact, 'hydrogen')

    @drumkits = Searches.artifacts_with_file_format(artifacts, 'h2drumkit')
    @songs = Searches.artifacts_with_file_format(artifacts, 'h2song')
    @patterns = Searches.artifacts_with_file_format(artifacts, 'h2pattern')

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

