class AddDownloadCountToArtifact < ActiveRecord::Migration
  def change
    add_column :artifacts, :download_count, :integer, default: 0
  end
end
