class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: Rails.application.config.omniauth_providers

  # Artifacts created by this user
  has_many :artifacts
  # Artifacts favorites by the user
  has_many :favorites
  has_many :favorite_artifacts, through: :favorites, source: :artifact

  validates :username, presence: true

  after_create :enqueue_get_avatar
  def enqueue_get_avatar
    Resque.enqueue(GetPublicAvatarDataWorker, self.id)
  end

  # For knock api auth
  def authenticate pass
    valid_password? pass
  end

  # For admin dashboard
  def name
    email
  end

  def self.find_by_omniauth auth
    User.where(provider: auth.provider, uid: auth.uid).first
  end

  # Creates or finds user by the information given via oauth
  #
  # Will match the info with an already registered email and try to update the data
  # BUT only if find_by_email=true because that means the oauth provider has the email verified
  def self.from_omniauth auth, find_by_email
    provider = auth['provider']
    uid = auth['uid']
    email = auth['info']['email']
    name = auth['info']['nickname'] || auth['info']['name'] || auth['info']['login']
    image = auth['info']['image']

    user = User.where(email: email).first

    # If a user is previously signed up with this email, just update his data
    if find_by_email && user.present?
      user.update_attributes(provider: provider, uid: uid, username: name, avatar: image)
    else

      user = create do |u|
        u.provider = provider
        u.uid = uid
        u.email = email
        u.username = name
        u.avatar = image
        u.password = Devise.friendly_token[0,20]
      end
    end

    user
  end
end
