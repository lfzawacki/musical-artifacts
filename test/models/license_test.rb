require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  def setup
    @by = License.find('by')
    @public = License.find('public')
    @copyleft = License.find('copyleft')
    @sample = License.find('cc-sample')
    @bync = License.find('by-nc')
    @bync3 = License.find('by-nc-3')
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

  test "getting images from static strings (by)" do
    assert_equal License.type_image('by'), "licenses/by.svg"
    assert_equal License.type_image('by', true), "licenses/by-small.svg"
  end

  test "getting images from static strings (cc catch all)" do
    assert_equal License.type_image('cc'), "licenses/cc.svg"
    assert_equal License.type_image('cc', true), "licenses/cc-small.svg"
  end

  test "getting images from static strings (same image for different versions of cc)" do
    assert_equal License.type_image('by-nc'), "licenses/by-nc.svg"
    assert_equal License.type_image('by-nc-3'), "licenses/by-nc.svg"
  end

  test "getting images from static strings (misc svg)" do
    assert_equal License.type_image('public'), "licenses/public.svg"
    assert_equal License.type_image('public', true), "licenses/public-small.svg"

    assert_equal License.type_image('copyleft'), "licenses/copyleft.svg"
    assert_equal License.type_image('copyleft', true), "licenses/copyleft-small.svg"
  end

  test "getting images from static strings (png licenses)" do
    assert_equal License.type_image('falv13'), "licenses/falv13.png"
    assert_equal License.type_image('falv13', true), "licenses/falv13-small.png"

    assert_equal License.type_image('cc-sample'), "licenses/cc-sample.png"
    assert_equal License.type_image('cc-sample', true), "licenses/cc-sample-small.png"

    assert_equal License.type_image('wtfpl'), "licenses/wtfpl.png"
    assert_equal License.type_image('wtfpl', true), "licenses/wtfpl-small.png"
  end

  test "getting images from static strings (gpls)" do
    assert_equal License.type_image('gpl'), "licenses/gpl.svg"
    assert_equal License.type_image('gpl', true), "licenses/gpl-small.svg"
    assert_equal License.type_image('gpl-v2'), "licenses/gpl.svg"
    assert_equal License.type_image('gpl-v3'), "licenses/gpl.svg"
  end

  test "getting images from static strings, returns nil" do
    assert_nil License.type_image('copyright')
    assert_nil License.type_image('various')
    assert_nil License.type_image('gray')
  end

  test "licenses without images" do
    skip
  end

end
