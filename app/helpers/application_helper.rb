module ApplicationHelper

  def application_title
    if content_for(:title).present?
      "#{content_for :title } | #{@setting.site_name}"
    else
      "#{@setting.site_name} | #{I18n.t('layouts.application.default_title')}"
    end
  end

end
