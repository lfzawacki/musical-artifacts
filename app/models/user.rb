class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Artifacts created by this user
  has_many :artifacts
  # Artifacts favorites by the user
  has_many :favorites
  has_many :favorite_artifacts, through: :favorites, source: :artifact

  validates :username, presence: true

  # For knock api auth
  def authenticate pass
    valid_password? pass
  end

  # For admin dashboard
  def name
    email
  end
end
