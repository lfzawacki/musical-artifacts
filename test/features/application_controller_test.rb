require 'test_helper'

class ApplicationControllerTest < Capybara::Rails::TestCase

  test "returns 406 Not Acceptable for unknown format" do
    # Simulating a request for an unsupported format (like a bot requesting markdown)
    visit artifacts_path(format: :markdown)

    assert_equal 406, page.status_code
  end

  test "returns 406 Not Acceptable for non-existent format" do
    # Simulating a request for a completely fabricated format
    visit artifacts_path(format: :made_up_format_that_does_not_exist)

    assert_equal 406, page.status_code
  end

  test "returns 406 Not Acceptable for common but unsupported format" do
    # Simulating a request for a common format we don't support (like a bot probing for vulnerabilities)
    visit artifacts_path(format: :php)

    assert_equal 406, page.status_code
  end

end
