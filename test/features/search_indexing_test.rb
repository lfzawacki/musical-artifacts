require 'test_helper'

class SearchIndexingTest < Capybara::Rails::TestCase

  test "does not prevent indexing on default pages without search parameters" do
    visit artifacts_path

    # The meta tag should not be present on a standard visit
    assert_no_css 'meta[name="robots"][content="noindex, nofollow"]', visible: false
  end

  test "prevents indexing when 'q' parameter is present" do
    visit artifacts_path(q: 'guitar')
    assert_css 'meta[name="robots"][content="noindex, nofollow"]', visible: false
  end

  test "prevents indexing when 'tags' parameter is present" do
    visit artifacts_path(tags: 'soundfont')
    assert_css 'meta[name="robots"][content="noindex, nofollow"]', visible: false
  end

  test "prevents indexing when 'apps' parameter is present" do
    visit artifacts_path(apps: 'guitarix')
    assert_css 'meta[name="robots"][content="noindex, nofollow"]', visible: false
  end

  test "prevents indexing when 'formats' parameter is present" do
    visit artifacts_path(formats: 'sf2')
    assert_css 'meta[name="robots"][content="noindex, nofollow"]', visible: false
  end

  test "prevents indexing when 'order' parameter is present" do
    visit artifacts_path(order: 'created_at')
    assert_css 'meta[name="robots"][content="noindex, nofollow"]', visible: false
  end

  test "prevents indexing when 'page' parameter is present" do
    visit artifacts_path(page: 2)
    assert_css 'meta[name="robots"][content="noindex, nofollow"]', visible: false
  end

  test "prevents indexing when multiple search parameters are present" do
    visit artifacts_path(q: 'test', page: 2)
    assert_css 'meta[name="robots"][content="noindex, nofollow"]', visible: false
  end
end
