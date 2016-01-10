class GetDataFromSf2Files < ActiveRecord::Migration
  def up
    StoredFile.where(format: 'sf2').each do |stored_file|
      stored_file.fetch_metadata_from_file
    end
  end

  def down
    # Nothing to do
  end
end
