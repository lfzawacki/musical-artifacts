require "test_helper"

class SettingTest < ActiveSupport::TestCase

  def setting
    @setting ||= Setting.new
  end

  def test_valid
    assert setting.valid?
  end

end
