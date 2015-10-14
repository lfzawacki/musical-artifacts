class AddFavoriteCountToArtifact < ActiveRecord::Migration
  def change
    add_column :artifacts, :favorite_count, :integer, default: 0
  end
end
