FactoryGirl.define do

  factory :user do
    email Forgery::Email.address
    admin false
  end
end