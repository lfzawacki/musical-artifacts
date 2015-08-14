class AddApprovedAndDownloadableToArtifact < ActiveRecord::Migration
  def change
    add_column :artifacts, :approved, :boolean, default: true
    add_column :artifacts, :downloadable, :boolean, default: true
  end
end
