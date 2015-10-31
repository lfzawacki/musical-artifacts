class GetFileListFromZippedFiles < ActiveRecord::Migration
  def up
    StoredFile.where('file LIKE ?', '%zip').each do |stored_file|
      stored_file.fetch_metadata_from_file
    end
  end

  def down
    # Nothing to do
  end
end
