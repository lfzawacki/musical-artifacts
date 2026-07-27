class AddFileSizeToStoredFiles < ActiveRecord::Migration
  def change
    add_column :stored_files, :file_size, :bigint
  end
end
