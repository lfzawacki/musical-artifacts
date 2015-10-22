module ArtifactsHelper

  def value_from_params
    search_str = Artifact.search_fields.map do |p|
      "#{p}: #{unescape_separators(params[p])}" if params[p]
    end
    [params[:q]].append(search_str).join(' ').gsub(/\s+/, ' ').strip
  end

  def split_param_terms terms
    remove_quotes(unescape_separators(terms)).split(',')
  end

  def external_link_to text, link=nil, opt=nil
    if block_given?
      link ||={}
      link_to(text, rel: 'nofollow', target: '_blank', class: link[:class] || "external-link normal") do
        yield
      end
    else
      opt ||={}
      link_to(text, link, rel: 'nofollow', target: '_blank', class: opt[:class] || "external-link normal")
    end
  end

  def domain_from_link link
    begin
      URI.parse(link).host
    rescue URI::InvalidURIError
      ''
    end
  end

  def format_from_link link
    link.split('.')[-1]
  end

  def icon_from_extension ext
    mime = Mime::Type::lookup_by_extension(ext)
    icons = {
      'application/x-bittorrent' => 'tint',

      'application/x-midi' => 'file-midi-o', # music

      'audio/x-soundfont' => 'file-audio-o',
      'audio/x-riff' => 'file-audio-o',
      'audio/x-wav' => 'file-audio-o',
      'audio/mpeg' => 'file-audio-o',
      'audio/ogg' => 'file-audio-o',

      'text/plain' => 'file-text-o',
      'text/html' => 'file-code-o',
      'application/xml' => 'file-code-o',

      'application/x-rar' => 'file-archive-o',
      'application/bzip2' => 'file-archive-o',
      'application/x-tar' => 'file-archive-o',
      'application/x-gzip' => 'file-archive-o',
      'application/zip' => 'file-archive-o'
    }

    "fa-#{icons[mime.to_s] || 'file-o'}"
  end

  def display_license artifact, opt={}
    license = artifact.license.short_name

    # copyright is boring, return just text
    return I18n.t("licenses.text.copyright", author: artifact.author) if license == 'copyright'

    img = image_tag(artifact.license.image_url(opt[:small]))

    if ['public', 'cc-sample', 'copyleft'].include?(license)
      link = I18n.t("licenses.link.#{license.gsub('-','_')}")
      text = I18n.t("licenses.text.#{license.gsub('-','_')}", author: artifact.author)
    elsif license.match(/gpl\-?(v2|v3)?/)
      version = $1.try(:chomp) || '1'
      link = I18n.t("licenses.link.gpl", version: "#{version}.0")
      text = I18n.t("licenses.text.gpl", version: "#{version}.0")
    else # cc licenses
      link = I18n.t("licenses.link.cc", type: license)
      text = I18n.t("licenses.text.cc")
      parts = license.split('-').map do |part|
        I18n.t("licenses.parts.#{part}")
      end
    end

    if opt[:small]
      content_tag :div, class: 'license' do
        content_tag(:a, img, href: artifacts_path(license: license)) +
        content_tag(:a, text, href: artifacts_path(license: license))
      end
    else
      content_tag :div, class: 'license' do
        content = content_tag(:a, img, href: link)

        inner_content = content_tag(:a, text, href: link)
        inner_content += tag(:br)
        parts.each do |part|
          inner_content += content_tag(:span, part, class: 'label license-label label-default')
        end if parts.present?

        content += content_tag(:div, inner_content, class: 'license-terms')
        content
      end
    end
  end

  def download_link artifact, opt = {}
    url = artifact_download_url(artifact, filename: artifact.file_name)
    link_to url, class: opt[:class], title: artifact.file_name, download: artifact.file_name, data: {no_turbolink: true} do
      yield
    end
  end

  private

  # Only unescape ' ' and ','
  def unescape_separators str
    return '' if str.blank?
    str.gsub('%20',' ').gsub('%2C', ',')
  end

  # Only unescape "'" and '"' ... it's confusing
  def remove_quotes str
    return '' if str.blank?
    str.gsub('"','')
  end

end
