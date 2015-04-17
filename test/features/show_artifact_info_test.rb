require "test_helper"

class ShowArtifactInfoTest < Capybara::Rails::TestCase
  setup do
    @artifact = artifacts(:one)
  end

  test "show artifact simple data" do
    visit artifact_path(@artifact)

    assert_content page, @artifact.name
    assert_content page, @artifact.description
    assert_content page, @artifact.author
  end
end
