class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :artifact

  after_create :update_favorite_count
  after_destroy :update_favorite_count

  validates :artifact, presence: true, uniqueness: { scope: :user, allow_blank: false }
  validates :user, presence: true

  def update_favorite_count
    artifact.update_column :favorite_count, artifact.favorites.count
  end
end
