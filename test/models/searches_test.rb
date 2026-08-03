require 'test_helper'

class SearchesTest < ActiveSupport::TestCase
  setup do
    # Feb 22nd 2026: Added a few more software tags because the DB is seeded with some default apps
    @artifacts = [
      FactoryBot.create(:artifact,
        name: 'Sounfont file',
        description: 'An artifact for a soundfont file',
        author: 'Smarmy',
        license: License.find('by'),
        file_format_list: ['sf2'],
        tag_list: ['soundfont', 'samples'],
        software_list: ['fluidsynth', 'saffronse', 'timidity'],
        extra_license_text: 'Please include my name'
      ),
      FactoryBot.create(:artifact,
        name: 'Guitar file',
        description: 'An artifact with a guitar related file',
        author: 'Ziggy',
        license: License.find('public'),
        file_format_list: ['gx'],
        tag_list: ['guitar', 'preset', 'tone', 'heavy metal'],
        software_list: ['guitarix'],
        extra_license_text: 'DWTFYW license'
      ),
      FactoryBot.create(:artifact,
        name: 'Zip file',
        description: 'An artifact with content compressed in a zip file and a crappy license',
        author: 'Zippy',
        license: License.find('copyright'),
        file_format_list: ['zip'],
        tag_list: ['compressed', 'samples']
      ),
      FactoryBot.create(:artifact,
        name: 'Drum package',
        description: 'An artifact of a drumkit, with drum samples',
        author: 'Drumbrum',
        license: License.find('by-sa'),
        file_format_list: ['rar'],
        tag_list: ['drums', 'drumkit', 'samples'],
        software_list: ['hydrogen']
      ),
      FactoryBot.create(:artifact,
        name: 'A synth sound preset',
        description: 'An artifact with synth sound presets',
        author: 'Moogaloog',
        license: License.find('copyright'),
        file_format_list: ['xmz'],
        tag_list: ['synth', 'preset'],
        software_list: ['zynaddsubfx', 'yoshimi', 'timidity']
      ),
      FactoryBot.create(:artifact,
        name: 'Acoustic guitar',
        description: 'A soundfont with sampled acoustic guitar sounds',
        author: 'Fire Mann',
        license: License.find('gpl-v2'),
        file_format_list: ['gig'],
        tag_list: ['acoustic guitar', 'samples'],
        software_list: ['linuxsampler']
      ),
      FactoryBot.create(:artifact,
        name: 'Banjo',
        description: 'A soundfont with sampled Banjo sounds',
        author: 'Fire Mann',
        license: License.find('gpl'),
        file_format_list: ['gig'],
        tag_list: ['banjo', 'samples'],
        software_list: ['linuxsampler', 'qsampler', 'fantasia']
      )]

    @scope = Artifact.all
  end

  test "#artifacts_by_metadata (search matching one tag)" do
    search = Searches::artifacts_by_metadata(@scope, 'heavy metal')

    assert_equal search.count, 0
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (search matching one app tag)" do
    search = Searches::artifacts_by_metadata(@scope, 'guitarix')

    assert_equal search.count, 0
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (search matching one format)" do
    search = Searches::artifacts_by_metadata(@scope, 'gig')

    assert_equal search.count, 0
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (search matching multiple from description)" do
    search = Searches::artifacts_by_metadata(@scope, 'artifact')

    assert_equal search.count, 5
    assert_includes search, @artifacts[0]
    assert_includes search, @artifacts[1]
    assert_includes search, @artifacts[2]
    assert_includes search, @artifacts[3]
    assert_includes search, @artifacts[4]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (search matching title or description)" do
    search = Searches::artifacts_by_metadata(@scope, 'guit')

    assert_equal search.count, 2
    assert_includes search, @artifacts[1]
    assert_includes search, @artifacts[5]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (search matching one author)" do
    search = Searches::artifacts_by_metadata(@scope, 'Fire Mann')

    assert_equal search.count, 2
    assert_includes search, @artifacts[5]
    assert_includes search, @artifacts[6]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (search matching multiple authors)" do
    search = Searches::artifacts_by_metadata(@scope, 'zi')

    assert_equal search.count, 2
    assert_includes search, @artifacts[1]
    assert_includes search, @artifacts[2]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (search matching via extra license text)" do
    search = Searches::artifacts_by_metadata(@scope, 'DWTFYW')

    assert_equal search.count, 1
    assert_includes search, @artifacts[1]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (search matching multiple fields)" do
    search = Searches::artifacts_by_metadata(@scope, 'license')

    assert_equal search.count, 2
    assert_includes search, @artifacts[1]
    assert_includes search, @artifacts[2]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "search matching metadata and URL encoded tags combined" do
    target_artifact = FactoryBot.create(:artifact,
      name: 'search element',
      description: 'testing the bug',
      tag_list: ['lg', 'tagb']
    )

    # The bug was triggered by parameters parsed from a URL query string
    search = Searches.new(Artifact.all, q: 'search', tags: 'lg%2Ctagb').call

    assert_equal 1, search.count
    assert_includes search, target_artifact
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_tagged_with (none found)" do
    search = Searches::artifacts_tagged_with(@scope, 'thatshowthenewsgoes')

    assert_equal search.count, 0
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_tagged_with (one tag)" do
    search = Searches::artifacts_tagged_with(@scope, 'guitar')

    assert_equal search.count, 1
    assert_includes search, @artifacts[1]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_tagged_with (one tag, two found)" do
    search = Searches::artifacts_tagged_with(@scope, 'preset')

    assert_equal search.count, 2
    assert_includes search, @artifacts[1]
    assert_includes search, @artifacts[4]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_tagged_with (two tags)" do
    search = Searches::artifacts_tagged_with(@scope, 'synth, preset')

    assert_equal search.count, 1
    assert_includes search, @artifacts[4]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_app_tagged_with (none found)" do
    search = Searches::artifacts_app_tagged_with(@scope, 'grassisbadah')

    assert_equal search.count, 0
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_app_tagged_with (one tag)" do
    search = Searches::artifacts_app_tagged_with(@scope, 'guitarix')

    assert_equal search.count, 1
    assert_includes search, @artifacts[1]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_app_tagged_with (one tag) two found" do
    search = Searches::artifacts_app_tagged_with(@scope, 'timidity')

    assert_equal search.count, 2
    assert_includes search, @artifacts[0]
    assert_includes search, @artifacts[4]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_app_tagged_with (two tags) exclusive" do
    search = Searches::artifacts_app_tagged_with(@scope, 'saffronse, zynaddsubfx')

    assert_equal search.count, 0
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_app_tagged_with (two tags, one found) exclusive" do
    search = Searches::artifacts_app_tagged_with(@scope, 'saffronse, fluidsynth')

    assert_equal search.count, 1
    assert_includes search, @artifacts[0]
  end

  test "#artifacts_licensed_as (none found)" do
    search = Searches::artifacts_licensed_as(@scope, 'wubalubadubadub')

    assert search.count, 0
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_licensed_as (copyright)" do
    search = Searches::artifacts_licensed_as(@scope, 'copyright')

    assert search.count, 2
    assert_includes search, @artifacts[2]
    assert_includes search, @artifacts[4]
    assert_kind_of ActiveRecord::Relation, search
  end

  # No more tests for searches of 2 licenses because we can only search for one at a time now
  test "#artifacts_licensed_as (public)" do
    search = Searches::artifacts_licensed_as(@scope, 'public')

    assert search.count, 1
    assert_includes search, @artifacts[1]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_licensed_as (by)" do
    search = Searches::artifacts_licensed_as(@scope, 'by')

    assert search.count, 1
    assert_includes search, @artifacts[0]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_licensed_as ('cc' as a license_type)" do
    search = Searches::artifacts_licensed_as(@scope, 'cc')

    assert search.count, 2
    assert_includes search, @artifacts[0]
    assert_includes search, @artifacts[3]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_licensed_as ('gpl' as a license_type)" do
    search = Searches::artifacts_licensed_as(@scope, 'gpl')

    assert search.count, 2
    assert_includes search, @artifacts[5]
    assert_includes search, @artifacts[6]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_with_file_format (none found)" do
    search = Searches::artifacts_with_file_format(@scope, 'exe')

    assert search.count, 0
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_with_file_format (zip)" do
    search = Searches::artifacts_with_file_format(@scope, 'zip')

    assert search.count, 1
    assert_includes search, @artifacts[2]
    assert_kind_of ActiveRecord::Relation, search
  end

  # Changing this test because we don't have inclusive searches for formats anymore
  test "#artifacts_with_file_format (rar)" do
    search = Searches::artifacts_with_file_format(@scope, 'rar')

    assert_equal search.count, 1
    assert_includes search, @artifacts[3]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_with_hash (none found)" do
    search = Searches::artifacts_with_hash(@scope, '01011001')

    assert_equal search.count, 0
    assert_kind_of ActiveRecord::Relation, search
  end


  test "#artifacts_with_hash (one found)" do
    @artifacts[0].update_attributes(file_hash: '01011001')
    search = Searches::artifacts_with_hash(@scope, '01011001')

    assert_equal search.count, 1
    assert_includes search, @artifacts[0]
    assert_kind_of ActiveRecord::Relation, search
  end

  test "artifact searches with empty or nil params returns the same scope" do

    [:artifacts_with_hash, :artifacts_licensed_as, :artifacts_with_file_format,
     :artifacts_tagged_with, :artifacts_app_tagged_with, :artifacts_by_metadata].each do |method|
      assert_equal @scope, Searches.send(method, @scope, '')
      assert_equal @scope, Searches.send(method, @scope, nil)

      assert_equal Artifact.none, Searches.send(method, Artifact.none, '')
      assert_equal Artifact.none, Searches.send(method, Artifact.none, nil)
    end
  end

  test "#tags (list all)" do
    tags = Searches.tags('')
    assert_equal 12, tags.count
  end

  test "#tags (find some)" do
    tags = Searches.tags('guitar')
    assert_equal 2, tags.count
    assert_includes tags.map(&:name), 'guitar'
    assert_includes tags.map(&:name), 'acoustic guitar'
  end

  test "#tags (find none)" do
    tags = Searches.tags('nonexistent')
    assert_equal 0, tags.count
  end

  test "#app_tags (list all)" do
    tags = Searches.app_tags('')
    assert_equal 11, tags.count
  end

  test "#app_tags (find some)" do
    tags = Searches.app_tags('s')
    assert_equal 8, tags.count
    assert_includes tags.map(&:name), 'saffronse'
    assert_includes tags.map(&:name), 'fluidsynth'
    assert_includes tags.map(&:name), 'linuxsampler'
  end

  test "#app_tags (find none)" do
    tags = Searches.app_tags('nonexistent')
    assert_equal 0, tags.count
  end

  test "#artifacts_by_metadata (non-alphanumeric query . does not crash)" do
    search = Searches::artifacts_by_metadata(@scope, '.')
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (non-alphanumeric query ! does not crash)" do
    search = Searches::artifacts_by_metadata(@scope, '!')
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (non-alphanumeric query with spaces does not crash)" do
    search = Searches::artifacts_by_metadata(@scope, '. ! @ #')
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#artifacts_by_metadata (non-alphanumeric chars ignored with valid term)" do
    search = Searches::artifacts_by_metadata(@scope, '@#$ guitar !')
    assert_includes search, @artifacts[1]
    assert_includes search, @artifacts[5]
  end

  test "#artifacts_by_metadata (non-alphanumeric query combined with valid tags)" do
    search = Searches.new(Artifact.all, q: '.', tags: 'soundfont', formats: 'sf2').call
    assert_equal 1, search.count
    assert_includes search, @artifacts[0]
  end

  test "#recent_tags" do
    skip
  end

  test "#by_metadata handles null bytes in query" do
    search = Searches.new(Artifact.all, q: "1\u0000guitar").call
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#by_metadata handles invalid UTF-8 bytes" do
    malicious_query = [0xC0, 0xA7, 0xC0, 0xA2].pack("C*").force_encoding("UTF-8")
    search = Searches.new(Artifact.all, q: "1#{malicious_query}guitar").call
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#by_metadata handles null byte and invalid UTF-8 combined" do
    malicious_query = "1\u0000\xC0\xA7\xC0\xA2%2527%2522"
    search = Searches.new(Artifact.all, q: malicious_query).call
    assert_kind_of ActiveRecord::Relation, search
  end

  test "#by_metadata handles only garbage bytes" do
    malicious_query = "\u0000\xC0\xA7\xC0\xA2"
    search = Searches.new(Artifact.all, q: malicious_query).call
    assert_kind_of ActiveRecord::Relation, search
    assert_equal Artifact.count, search.count
  end

  test "#artifacts_by_metadata handles null bytes in query" do
    search = Searches::artifacts_by_metadata(@scope, "drum\u0000kit")
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[3]
  end

  test "#artifacts_by_metadata handles invalid UTF-8 bytes" do
    malicious_query = [0xC0, 0xA7, 0xC0, 0xA2].pack("C*").force_encoding("UTF-8")
    search = Searches::artifacts_by_metadata(@scope, "drum#{malicious_query}kit")
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[3]
  end

  test "#artifacts_by_metadata handles only garbage in query" do
    malicious_query = "\u0000\xC0\xA7\xC0\xA2"
    search = Searches::artifacts_by_metadata(@scope, malicious_query)
    assert_kind_of ActiveRecord::Relation, search
    assert_equal @scope.count, search.count
  end

  ##
  # Tests for invalid UTF-8 bytes in all parameter vectors
  ##

  test "#by_hash handles invalid UTF-8 in hash param" do
    search = Searches.new(Artifact.all, q: "guitar", hash: bad_bytes).call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[1]
  end

  test "#by_hash handles null byte in hash param" do
    search = Searches.new(Artifact.all, q: "guitar", hash: "\u0000").call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[1]
  end

  test "#collect_tag_conditions handles invalid UTF-8 in tags param" do
    search = Searches.new(Artifact.all, tags: "guitar#{bad_bytes}").call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[1]
  end

  test "#collect_tag_conditions handles null byte in tags param" do
    search = Searches.new(Artifact.all, tags: "guitar\u0000").call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[1]
  end

  test "#collect_tag_conditions handles invalid UTF-8 in apps param" do
    search = Searches.new(Artifact.all, apps: "fluidsynth#{bad_bytes}").call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[0]
  end

  test "#collect_tag_conditions handles null byte in apps param" do
    search = Searches.new(Artifact.all, apps: "fluidsynth\u0000").call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[0]
  end

  test "#collect_tag_conditions handles invalid UTF-8 in formats param" do
    search = Searches.new(Artifact.all, formats: "sf2#{bad_bytes}").call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[0]
  end

  test "#collect_tag_conditions handles null byte in formats param" do
    search = Searches.new(Artifact.all, formats: "sf2\u0000").call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[0]
  end

  test "#by_license handles invalid UTF-8 in license param" do
    search = Searches.new(Artifact.all, license: "by#{bad_bytes}").call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[0]
  end

  test "#by_license handles null byte in license param" do
    search = Searches.new(Artifact.all, license: "by\u0000").call
    assert_kind_of ActiveRecord::Relation, search
    assert_includes search, @artifacts[0]
  end

  test "#by_license handles only garbage in license param" do
    search = Searches.new(Artifact.all, license: bad_bytes).call
    assert_kind_of ActiveRecord::Relation, search
    assert_equal Artifact.count, search.count
  end

  test "Searches.tags handles invalid UTF-8" do
    result = Searches.tags("gui#{bad_bytes}tar")
    assert_kind_of ActiveRecord::Relation, result
    assert result.count >= 1
    assert_includes result.map(&:name), "guitar"
  end

  test "Searches.tags handles null byte" do
    result = Searches.tags("gui\u0000tar")
    assert_kind_of ActiveRecord::Relation, result
    assert result.count >= 1
    assert_includes result.map(&:name), "guitar"
  end

  test "Searches.app_tags handles invalid UTF-8" do
    result = Searches.app_tags("fluids#{bad_bytes}ynth")
    assert_kind_of ActiveRecord::Relation, result
    assert result.count >= 1
    assert_includes result.map(&:name), "fluidsynth"
  end

  test "Searches.app_tags handles null byte" do
    result = Searches.app_tags("fluids\u0000ynth")
    assert_kind_of ActiveRecord::Relation, result
    assert result.count >= 1
    assert_includes result.map(&:name), "fluidsynth"
  end

  test "Searches.file_format_tags handles invalid UTF-8" do
    result = Searches.file_format_tags("s#{bad_bytes}f2")
    assert_kind_of ActiveRecord::Relation, result
    assert result.count >= 1
    assert_includes result.map(&:name), "sf2"
  end

  test "Searches.file_format_tags handles null byte" do
    result = Searches.file_format_tags("s\u0000f2")
    assert_kind_of ActiveRecord::Relation, result
    assert result.count >= 1
    assert_includes result.map(&:name), "sf2"
  end

  test "Searches.artifacts_tagged_with handles invalid UTF-8" do
    result = Searches.artifacts_tagged_with(@scope, "gui#{bad_bytes}tar")
    assert_kind_of ActiveRecord::Relation, result
    assert_includes result, @artifacts[1]
  end

  test "Searches.artifacts_tagged_with handles null byte" do
    result = Searches.artifacts_tagged_with(@scope, "gui\u0000tar")
    assert_kind_of ActiveRecord::Relation, result
    assert_includes result, @artifacts[1]
  end

  test "Searches.artifacts_app_tagged_with handles invalid UTF-8" do
    result = Searches.artifacts_app_tagged_with(@scope, "fluids#{bad_bytes}ynth")
    assert_kind_of ActiveRecord::Relation, result
    assert_includes result, @artifacts[0]
  end

  test "Searches.artifacts_app_tagged_with handles null byte" do
    result = Searches.artifacts_app_tagged_with(@scope, "fluids\u0000ynth")
    assert_kind_of ActiveRecord::Relation, result
    assert_includes result, @artifacts[0]
  end

  test "Searches.artifacts_licensed_as handles invalid UTF-8" do
    result = Searches.artifacts_licensed_as(@scope, "b#{bad_bytes}y")
    assert_kind_of ActiveRecord::Relation, result
    assert_includes result, @artifacts[0]
  end

  test "Searches.artifacts_licensed_as handles null byte" do
    result = Searches.artifacts_licensed_as(@scope, "b\u0000y")
    assert_kind_of ActiveRecord::Relation, result
    assert_includes result, @artifacts[0]
  end

  test "Searches.artifacts_licensed_as handles only garbage" do
    result = Searches.artifacts_licensed_as(@scope, bad_bytes)
    assert_kind_of ActiveRecord::Relation, result
    assert_equal @scope.count, result.count
  end

  private

  def bad_bytes
    [0xC0, 0xA7, 0xC0, 0xA2].pack("C*").force_encoding("UTF-8")
  end

end
