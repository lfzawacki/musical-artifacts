FactoryGirl.define do

  factory :setting do
    data(:hostname => 'tests.musical-artifacts.com',
         :site_name => 'The Musical Artifact Experience'
    )
  end

end