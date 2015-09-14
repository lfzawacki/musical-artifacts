class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Artifacts created by this user
  has_many :artifacts

  # For knock api auth
  def authenticate pass
    valid_password? pass
  end
end
