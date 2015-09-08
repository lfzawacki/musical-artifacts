class AddDownloadCountToStoredFiles < ActiveRecord::Migration
  def change
    add_column :stored_files, :download_count, :integer, default: 0
  end
end
