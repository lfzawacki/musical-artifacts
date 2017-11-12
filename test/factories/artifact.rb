FactoryBot.define do

  factory :artifact do
    name { Faker::Name.name }
    author { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    downloadable true
    approved true

    license { License.find('by') }
  end

end