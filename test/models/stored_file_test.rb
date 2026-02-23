require "test_helper"

class StoredFileTest < ActiveSupport::TestCase

  setup do
    @file_wav = StoredFile.new
    @file_wav.file = File.open('test/fixtures/files/audio.wav')

    @file_zip = StoredFile.new
    @file_zip.file = File.open('test/fixtures/files/under.zip')
  end

  test "save file" do
    assert @file_wav.save
    assert @file_wav.valid?
    assert_equal @file_wav.format, 'wav'
  end

  test "enqueue_fetch_metadata" do
    @file_zip.save
    @file_zip.fetch_metadata_from_file

    assert_equal @file_zip.format, 'zip'
    assert_includes @file_zip.file_list, 'SpdrCider'
    assert_includes @file_zip.file_list, 'HushPupe'
    assert_includes @file_zip.file_list, 'HotCat'
    assert_includes @file_zip.file_list, 'ButtsPie'
    assert_includes @file_zip.file_list, 'AnnoyDog'
  end

end
