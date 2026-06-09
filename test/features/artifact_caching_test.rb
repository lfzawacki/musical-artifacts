require 'test_helper'

class ArtifactCachingTest < Capybara::Rails::TestCase
  setup do
    @license = License.first
    @artifact = Artifact.create!(
      name: 'Cacheable Artifact',
      author: 'Test Author',
      description: 'Original Description',
      license: @license,
      approved: true
    )

    # Temporarily enable caching for this test suite
    ActionController::Base.perform_caching = true
    Rails.cache.clear
  end

  teardown do
    # Disable caching again so it doesn't leak into other tests
    ActionController::Base.perform_caching = false
    Rails.cache.clear
  end

  test 'invalidates the index cache when the artifact is updated' do
    visit artifacts_path
    assert_content 'Original Description'

    # Update the artifact in the background
    @artifact.update!(description: 'Updated Index Description')

    # Reload the page and check that the cache was broken
    visit artifacts_path
    assert_content 'Updated Index Description'
    assert_no_content 'Original Description'
  end

  test 'invalidates the show cache when the artifact is updated' do
    visit artifact_path(@artifact)
    assert_content 'Original Description'

    # Update the artifact in the background
    @artifact.update!(description: 'Updated Show Description')

    # Reload the page and check that the cache was broken
    visit artifact_path(@artifact)
    assert_content 'Updated Show Description'
    assert_no_content 'Original Description'
  end

  test 'invalidates the show cache when a related StoredFile is created via touch true' do
    visit artifact_path(@artifact)
    assert_no_content 'Download'

    # Create a stored file using the fixture_file helper from test_helper.rb.
    # Because of the belongs_to :artifact, touch: true association,
    # this will update artifact.updated_at and automatically bust the fragment cache!
    @artifact.stored_files.create! file: fixture_file('file.zip')

    visit artifact_path(@artifact)

    # The file tree partial is inside the cache block and should now render the new file_list data
    assert_link I18n.t('artifacts.side_buttons.download'), @artifact.download_path
  end
end
