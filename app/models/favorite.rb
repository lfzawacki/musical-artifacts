class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :artifact

  validates :artifact, presence: true, uniqueness: { scope: :user, allow_blank: false }
  validates :user, presence: true
end
