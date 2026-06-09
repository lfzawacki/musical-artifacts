require 'rails_helper'

RSpec.feature 'Artifact Caching', type: :feature do
  let!(:license) { License.create!(name: 'MIT License', short_name: 'mit') }
  let!(:artifact) { Artifact.create!(name: 'Cacheable Artifact', author: 'Test Author', description: 'Original Description', license: license, approved: true) }

  before do
    # Temporarily enable caching for this test suite
    ActionController::Base.perform_caching = true
    Rails.cache.clear
  end

  after do
    # Disable caching again so it doesn't leak into other tests
    ActionController::Base.perform_caching = false
    Rails.cache.clear
  end

  scenario 'invalidates the index cache when the artifact is updated' do
    visit artifacts_path

    expect(page).to have_content('Original Description')

    # Update the artifact in the background
    artifact.update!(description: 'Updated Index Description')

    # Reload the page and check that the cache was broken
    visit artifacts_path
    expect(page).to have_content('Updated Index Description')
    expect(page).not_to have_content('Original Description')
  end

  scenario 'invalidates the show cache when the artifact is updated' do
    visit artifact_path(artifact)

    expect(page).to have_content('Original Description')

    # Update the artifact in the background
    artifact.update!(description: 'Updated Show Description')

    # Reload the page and check that the cache was broken
    visit artifact_path(artifact)
    expect(page).to have_content('Updated Show Description')
    expect(page).not_to have_content('Original Description')
  end

  scenario 'invalidates the show cache when a related StoredFile is created (via touch: true)' do
    visit artifact_path(artifact)

    expect(page).not_to have_content('new_magic_file.txt')

    # Create a stored file. Because of the `belongs_to :artifact, touch: true` association,
    # this will update `artifact.updated_at` and automatically bust the fragment cache!
    artifact.stored_files.create!(format: 'zip', file_list: ['new_magic_file.txt'])

    visit artifact_path(artifact)

    # The file tree partial is inside the cache block and should now render the new file_list data
    expect(page).to have_content('new_magic_file.txt')
  end
end
