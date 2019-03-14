FactoryBot.define do

  factory :app do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    url { "http://#{Faker::Internet.domain_name}" }
  end

end
