require 'test_helper'

class ArtifactTest < ActiveSupport::TestCase

  setup do
    @artifact = FactoryGirl.create(:artifact, file: fixture_file('example.gx'))
    @no_file = FactoryGirl.create(:artifact)
  end

  test 'validate name presence on create' do
    artifact = FactoryGirl.build(:artifact, name: nil)

    artifact.save
    assert !artifact.valid?

    assert_includes artifact.errors, :name
  end

  test 'validates name is unique on create' do
    artifact1 = FactoryGirl.build(:artifact, name: 'Volte-face')
    artifact2 = FactoryGirl.build(:artifact, name: 'Volte-face')

    artifact1.save
    assert artifact1.valid?
    assert artifact1.persisted?

    artifact2.save
    assert !artifact2.valid?

    assert_includes artifact2.errors, :name
  end

  test 'validate license presence on create' do
    artifact = FactoryGirl.build(:artifact, license: nil)

    artifact.save
    assert !artifact.valid?

    assert_includes artifact.errors, :license
  end

  test 'validates author presence on create' do
    artifact = FactoryGirl.build(:artifact, author: nil)

    artifact.save
    assert !artifact.valid?

    assert_includes artifact.errors, :author
  end

  test '.generate_file_hash' do
    skip
  end

  test '.save_new_file' do
    skip
  end

  test '.file= ' do
    skip
  end

  test '.get_file_by_name filename' do
    assert @artifact.get_file_by_name('example.gx')
    assert_nil @artifact.get_file_by_name('inexistent')
  end

  test '.get_file_by_name filename (2 files with the same name, finds last one)' do
    skip
  end

  test '.file_name' do
    assert_equal @artifact.file_name, 'example.gx'
  end

  test '.file_format' do
    assert_equal @artifact.file_format, 'gx'
  end

  test '.file_format= format' do
    @no_file.update_attributes file_format: 'zip'

    assert_equal @no_file.file_format, 'zip'
    # assert_include @no_file.file_formats, 'zip'
  end

  test '.mirrors=m' do
    @artifact.update_attributes mirrors: ['https://mysite.org/file', 'http://hissite.com/thefile']
  end

  test '.more_info_urls=m' do
  end

  test '.related max=5' do
    skip
  end

  test '.download_path' do
    assert_equal @artifact.download_path, "/artifacts/#{@artifact.id}/#{@artifact.file_name}"
  end

end
