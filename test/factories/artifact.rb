FactoryGirl.define do

  factory :artifact do
    name { |n| "#{Forgery::Name.full_name} #{n}" } # generating an unique name
    author Forgery::Name.full_name
    description Forgery::LoremIpsum.paragraph
    downloadable true
    approved true

    license { License.find('by') }
  end

end