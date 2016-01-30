class BackfillFavoriteActivities < ActiveRecord::Migration
  def up
    Favorite.find_each do |fav|
      act = fav.artifact.create_activity key: 'artifact.favorite', owner: fav.user
      act.update_column :created_at, fav.created_at
    end
  end

  def down
    PublicActivity::Activity.where(key: 'artifact.favorite').delete_all
  end
end
