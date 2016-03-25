# This controller implements a xml backend that returns a
# drumkit list in a format Hydrogen can read

# XML spec is taken from:
# https://github.com/hydrogen-music/hydrogen/wiki/Soundlibrary-download-feature
class HydrogenDrumkitsController < InheritedResources::Base

  # rescue_from ActionController::UnknownFormat, with: :remove_trailing_whitespaces
  before_filter :remove_trailing_whitespaces, only: [:index]

  def index
    render_drumkits
  end

  private

  def render_drumkits
    # Hydrogen artifacts with a file of .h2drumkit format
    @drumkits = Searches.artifacts_app_tagged_with(Artifact, 'hydrogen')
    @drumkits = @drumkits.map do |drumkit|
      {
        name: drumkit.name, url: url_from_artifact(drumkit),
        info: description_with_tags(drumkit), author: drumkit.author, license: drumkit.license.name
      }
    end

    @drumkits.select! { |drumkit| drumkit[:url].present? }

    respond_to do |format|
      format.xml do
        render xml: @drumkits.to_xml(root: :drumkit_list, dasherize: false, children: :drumkit, skip_types: true)
      end
    end
  end

  # Tries to get an .h2drumkit download from the site first, then the first mirror
  # If no file is found return nil
  def url_from_artifact artifact
    file = artifact.stored_files.last
    mirrors = artifact.mirrors
    url = nil

    if file.try(:format) == 'h2drumkit'
      url = artifact_download_url(artifact, file.name)
    else
      mirrors.select! { |mirror| File.extname(mirror) == '.h2drumkit' }
      url = mirrors.first
    end

    url
  end

  def description_with_tags drumkit
    "<p>Tagged with #{drumkit.tag_list.join(', ')}</p> #{drumkit.description_html}"
  end

  # It's common for users to include trailing whitespaces in the URL and this will cause server errors
  # because xml%20 is an invalid format. This tries to get back from this error
  def remove_trailing_whitespaces
    if params[:format].match(/xml\s+/)
      request.format = :xml
      render_drumkits
    end
  end
end

