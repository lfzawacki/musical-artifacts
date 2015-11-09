class GetFileListFromZippedFiles < ActiveRecord::Migration
  def up
    StoredFile.where(format: 'zip').each do |stored_file|
      stored_file.fetch_metadata_from_file
    end
  end

  def down
    # Nothing to do
  end
end
