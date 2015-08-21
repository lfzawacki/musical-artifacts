FactoryGirl.define do

  factory :license do
    name Forgery::Name.full_name
    short_name 'by'
  end

end