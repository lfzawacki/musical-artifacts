FactoryGirl.define do

  factory :artifact do
    name { Forgery::Name.full_name }
    author { Forgery::Name.full_name }
    description { Forgery::LoremIpsum.paragraph }
    downloadable true
    approved true

    license { License.find('by') }
  end

end