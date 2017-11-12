# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :favorite do
    artifact
    user
  end
end
