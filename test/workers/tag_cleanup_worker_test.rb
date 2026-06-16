require 'test_helper'

class TagCleanupWorkerTest < ActiveSupport::TestCase
  setup do
    @tag_artifact     = FactoryBot.create(:artifact, tag_list: 'sf2')
    @software_artifact = FactoryBot.create(:artifact, software_list: 'poliphone')
    @format_artifact   = FactoryBot.create(:artifact, file_format_list: '.sf2')
    @remove_artifact   = FactoryBot.create(:artifact, software_list: 'sega')
    @unaffected        = FactoryBot.create(:artifact,
                            tag_list: 'piano',
                            file_format_list: 'aiff',
                            software_list: 'fluidsynth')
  end

  test 'moves tags from one context to another' do
    config = {
      'moves' => [{ 'from' => 'tags', 'to' => 'file_formats', 'values' => ['sf2'] }]
    }
    TagCleanupWorker.perform(config)
    @tag_artifact.reload
    assert_not_includes @tag_artifact.tag_list, 'sf2'
    assert_includes @tag_artifact.file_format_list, 'sf2'
  end

  test 'renames tags within a context' do
    config = { 'renames' => { 'software' => { 'poliphone' => 'polyphone' } } }
    TagCleanupWorker.perform(config)
    @software_artifact.reload
    assert_not_includes @software_artifact.software_list, 'poliphone'
    assert_includes @software_artifact.software_list, 'polyphone'
  end

  test 'removes tags from a context' do
    config = { 'removes' => [{ 'from' => 'software', 'values' => ['sega'] }] }
    TagCleanupWorker.perform(config)
    @remove_artifact.reload
    assert_not_includes @remove_artifact.software_list, 'sega'
  end

  test 'strips leading dots from file format tags' do
    config = { 'strip_dots' => ['file_formats'] }
    TagCleanupWorker.perform(config)
    @format_artifact.reload
    assert_not_includes @format_artifact.file_format_list, '.sf2'
    assert_includes @format_artifact.file_format_list, 'sf2'
  end

  test 'unaffected artifacts are not changed' do
    config = {
      'moves'   => [{ 'from' => 'tags', 'to' => 'file_formats', 'values' => ['sf2'] }],
      'removes' => [{ 'from' => 'software', 'values' => ['sega'] }]
    }
    before = {
      tags: @unaffected.tag_list.dup,
      formats: @unaffected.file_format_list.dup,
      software: @unaffected.software_list.dup
    }
    TagCleanupWorker.perform(config)
    @unaffected.reload
    assert_equal before[:tags],     @unaffected.tag_list
    assert_equal before[:formats],  @unaffected.file_format_list
    assert_equal before[:software], @unaffected.software_list
  end

  test 'all rule types can be applied together' do
    config = {
      'moves'   => [{ 'from' => 'tags', 'to' => 'file_formats', 'values' => ['sf2'] }],
      'renames' => { 'software' => { 'poliphone' => 'polyphone' } },
      'removes' => [{ 'from' => 'software', 'values' => ['sega'] }],
      'strip_dots' => ['file_formats']
    }
    TagCleanupWorker.perform(config)

    @tag_artifact.reload
    assert_not_includes @tag_artifact.tag_list, 'sf2'
    assert_includes @tag_artifact.file_format_list, 'sf2'

    @software_artifact.reload
    assert_not_includes @software_artifact.software_list, 'poliphone'
    assert_includes @software_artifact.software_list, 'polyphone'

    @remove_artifact.reload
    assert_not_includes @remove_artifact.software_list, 'sega'

    @format_artifact.reload
    assert_not_includes @format_artifact.file_format_list, '.sf2'
    assert_includes @format_artifact.file_format_list, 'sf2'
  end
end
