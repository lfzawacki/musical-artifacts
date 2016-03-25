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

  test '.set_app_tags_from_format (guitarix)' do
    @gx_artifact = Artifact.create(name: 'Guitarix Preset', license: License.find('by'),
      author: 'Hermann', file: fixture_file('example.gx'))

    assert @gx_artifact.persisted?
    assert @gx_artifact.file_format_list.include?('gx')
    assert @gx_artifact.software_list.include?('guitarix')
  end

  test '.set_app_tags_from_format (soundfont)' do
    @sf2 = Artifact.create(name: 'Sf2 file', license: License.find('by'),
      author: 'Fabio', file: fixture_file('soundfont.sf2'))

    assert @sf2.persisted?
    assert @sf2.file_format_list.include?('sf2')
    assert @sf2.software_list.include?('fluidsynth')
    assert @sf2.software_list.include?('linuxsampler')
    assert @sf2.software_list.include?('timidity')
    assert @sf2.software_list.include?('qsampler')
    assert @sf2.software_list.include?('qsynth')
    assert @sf2.software_list.include?('fantasia')
  end

  test '.set_app_tags_from_format (zipped soundfont)' do
    @sf2 = Artifact.create(name: 'Sf2 file', license: License.find('by'),
      author: 'Fabio', file: fixture_file('under.zip'), file_format_list: ['sf2'])

    assert @sf2.persisted?
    assert @sf2.file_format_list.include?('sf2')
    assert @sf2.file_format_list.include?('zip')
    assert @sf2.software_list.include?('fluidsynth')
    assert @sf2.software_list.include?('linuxsampler')
    assert @sf2.software_list.include?('timidity')
    assert @sf2.software_list.include?('qsampler')
    assert @sf2.software_list.include?('qsynth')
    assert @sf2.software_list.include?('fantasia')
  end

  test '.set_app_tags_from_format (custom app)' do
    @app = App.create(name: 'H3H3 Productions', file_format_list: ['exe', 'riot', 'goof', 'gaff','romp'], software_list: 'h3h3')
    @artifact = Artifact.create(name: 'TimmyB', license: License.find('by'), author: 'Ethan', file_format_list: ['goof'])

    assert @artifact.persisted?
    assert @artifact.file_format_list.include?('goof')
    assert @artifact.software_list.include?('h3h3')

    @artifact = Artifact.create(name: 'Always Tip', license: License.find('by'), author: 'Hila', file_format_list: ['romp'])

    assert @artifact.persisted?
    assert @artifact.file_format_list.include?('romp')
    assert @artifact.software_list.include?('h3h3')
  end

  test '.set_app_tags_from_format (with extra software in the list)' do
    @artifact = Artifact.create(name: 'Clean Guitar Preset', license: License.find('by'), author: 'lfz',
      file_format_list: ['gx'], software_list: ['rakkarack'])

    assert @artifact.persisted?
    assert @artifact.file_format_list.include?('gx')
    assert @artifact.software_list.include?('guitarix')
    assert @artifact.software_list.include?('rakkarack')
  end


  test '.get_file_by_name filename' do
    assert @artifact.get_file_by_name('example.gx')
    assert_nil @artifact.get_file_by_name('inexistent')
  end

  test '.get_file_by_name filename (2 files with the same name, finds most recent one)' do
    # add a second file with the same name
    @artifact.update_attributes(file: fixture_file('example.gx'))

    # TODO a way to downlaod older files
    assert @artifact.get_file_by_name('example.gx')
    assert_equal @artifact.get_file_by_name('example.gx'), @artifact.stored_files.last
  end

  test '.get_file_by_name filename (2 files finds both by name)' do
    @artifact.update_attributes(file: fixture_file('file.zip'))

    assert @artifact.get_file_by_name('example.gx')
    assert @artifact.get_file_by_name('file.zip')
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
    assert_includes @no_file.file_format_list, 'zip'
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

  test '.owned_by?(user)' do
    user = FactoryGirl.create(:user)

    # Better treat the case where user=nil and NOT return true then
    assert_equal @artifact.owned_by?(nil), false
    assert_equal @artifact.owned_by?(user), false

    @artifact.update_attributes(user: user)

    assert_equal @artifact.owned_by?(user), true
  end
end
