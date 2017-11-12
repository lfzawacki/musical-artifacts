FactoryBot.define do

  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8, 20) }
    username { Faker::Internet.user_name }
    admin false
  end
end