FactoryBot.define do

  factory :setting do
    data {
      { :hostname => 'tests.musical-artifacts.com',
        :site_name => 'The Musical Artifact Experience',
        :artifacts_per_page => '25',
        :min_tag_search => '1',
        :min_app_search => '1',
        :min_format_search => '1',
        :max_tag_results => '10',
        :max_app_results => '10',
        :max_format_results => '10',
        :max_artifact_tags => '10',
        :max_artifact_apps => '10',
        :max_artifact_formats => '5' }
    }
  end

end
