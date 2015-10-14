class CountFavoritesForEachArtifact < ActiveRecord::Migration
  def up
    Artifact.all.each do |artifact|
      artifact.update_attribute :favorite_count, artifact.favorites.count
    end
  end

  def down
    # nothing needs to be done
  end
end
