require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  def setup
  end

  test "finds by id and short_name" do
    assert License.find('by').present?
    assert License.find(licenses(:by).id).present?

    assert_equal License.find('by'), License.find(licenses(:by).id)

    assert License.find('public').present?
    assert License.find(licenses(:public).id).present?

    assert_equal License.find('public'), License.find(licenses(:public).id)
  end

  test "getting normal image links" do
    assert_equal licenses(:by).image_url, "licenses/by.svg"
    assert_equal licenses(:public).image_url, "licenses/public.svg"
  end

  test "getting small image links" do
    assert_equal licenses(:by).image_url(true), "licenses/by-small.svg"
    assert_equal licenses(:public).image_url(true), "licenses/public-small.svg"
  end

end
