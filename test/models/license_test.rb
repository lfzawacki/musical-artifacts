require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  def setup
    @by = License.find('by')
    @public = License.find('public')
    @copyleft = License.find('copyleft')
    @sample = License.find('cc-sample')
  end

  test "finds by id and short_name" do
    assert License.find('by').present?
    assert License.find(@by.id).present?

    assert_equal License.find('by'), License.find(@by.id)

    assert License.find('public').present?
    assert License.find(@public.id).present?

    assert_equal License.find('public'), License.find(@public.id)
  end

  test "getting normal image links" do
    assert_equal @by.image_url, "licenses/by.svg"
    assert_equal @public.image_url, "licenses/public.svg"
  end

  test "getting small image links" do
    assert_equal @by.image_url(true), "licenses/by-small.svg"
    assert_equal @public.image_url(true), "licenses/public-small.svg"
  end

  test "licenses without images" do
    skip
  end

end
