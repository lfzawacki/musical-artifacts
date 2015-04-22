module ArtifactsHelper

  def display_license artifact, opt={}
    license = artifact.license.short_name

    # copyright is boring
    return I18n.t("licenses.text.copyright", author: artifact.author) if license == 'copyright'

    img = image_tag(artifact.license.image_url(opt[:small]))

    if 'public' == license
      link = I18n.t("licenses.link.public")
      text = I18n.t("licenses.text.public")
    else # cc licenses
      link = I18n.t("licenses.link.cc", type: license)
      text = I18n.t("licenses.text.cc")
      parts = license.split('-').map do |part|
        I18n.t("licenses.parts.#{part}")
      end
    end

    if opt[:small]
      content_tag :div, class: 'license' do |div|
        content_tag(:a, img, href: link) +
        content_tag(:a, text, href: link)
      end
    else
      content_tag :div, class: 'license' do |div|
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

end
