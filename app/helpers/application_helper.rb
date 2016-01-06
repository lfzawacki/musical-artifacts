module ApplicationHelper

  def application_title
    if content_for(:title).present?
      "#{content_for :title } | #{@setting.site_name}"
    else
      "#{@setting.site_name} | #{I18n.t('layouts.application.default_title')}"
    end
  end

  # Tells whether or not a referrer URL came from our application
  def internal_referrer?
    request.referrer && URI.parse(request.referrer).host == request.host
  end

end
