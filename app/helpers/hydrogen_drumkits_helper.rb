module HydrogenDrumkitsHelper

  # Tries to get an .h2* download from the site first, then the first mirror
  # If no file is found return nil
  def url_from_artifact artifact
    file = artifact.stored_files.last
    mirrors = artifact.mirrors
    url = nil

    if ['h2drumkit', 'h2song', 'h2pattern'].include? file.try(:format)
      url = artifact_download_url(artifact, file.name)
    elsif mirrors.present?
      mirrors.select! { |mirror| File.extname(mirror).match /h2(drumkit|song|pattern)/ }
      url = mirrors.first
    end

    url
  end

  # It's valid if it has a non nil url
  def is_valid_node?(node)
    url_from_artifact(node)
  end

  def description_with_tags drumkit
    "<p>Tagged with #{drumkit.tag_list.join(', ')}</p> #{drumkit.description_html}"
  end

end