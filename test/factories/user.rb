FactoryGirl.define do

  factory :user do
    email { Forgery::Email.address }
    password { Forgery::Basic.password(:at_least => 8, :at_most => 20) }
    admin false
  end
end