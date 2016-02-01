class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :artifact

  after_create :update_favorite_count
  after_destroy :update_favorite_count

  after_create :create_activity
  after_destroy :destroy_activity

  validates :artifact, presence: true, uniqueness: { scope: :user, allow_blank: false }
  validates :user, presence: true

  def update_favorite_count
    artifact.update_column :favorite_count, artifact.favorites.count
  end

  private
  def create_activity
    artifact.create_activity key: 'artifact.favorite', owner: user
  end

  def destroy_activity
    PublicActivity::Activity.where(key: 'artifact.favorite', owner: user, trackable: artifact).delete_all
  end

end
