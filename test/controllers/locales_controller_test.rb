require "test_helper"

class LocalesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    # setup some test values
    I18n.default_locale = :en
    I18n.available_locales = [:en, :de, :'pt-BR']
  end

  test 'set locale with valid values' do
    assert session[:locale].blank?

    post :set_locale, locale: 'pt-BR'

    assert_equal 'pt-BR', session[:locale]

    post :set_locale, locale: 'en'

    assert_equal 'en', session[:locale]
  end

  test 'set locale with invalid value doesnt change the locale' do
    assert session[:locale].blank?

    post :set_locale, locale: 'jp'

    assert session[:locale].blank?

    post :set_locale, locale: 'en'
    post :set_locale, locale: 'jp'

    assert_equal 'en', session[:locale]
  end

  test 'set locale with blank value doesnt change the locale' do
    assert session[:locale].blank?

    post :set_locale, locale: ''

    assert session[:locale].blank?

    post :set_locale, locale: 'pt-BR'
    post :set_locale, locale: ''

    assert_equal 'pt-BR', session[:locale]
  end

end
