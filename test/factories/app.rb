FactoryGirl.define do

  factory :app do
    name Forgery::Name.full_name
    description Forgery::LoremIpsum.paragraph
    url "http://#{Forgery::Internet.domain_name}"
  end

end