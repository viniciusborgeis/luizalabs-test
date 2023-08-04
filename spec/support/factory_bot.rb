require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  factory :user do
    id { Faker::Number.number(digits: 1) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6, max_length: 14) }
    name { Faker::Name.name }
    role { 'athlete' }
  end

  factory :modality do
    id { Faker::Number.number(digits: 1) }
    name { Faker::Name.name }
    unit { 'meters' }
  end

  factory :result do
    id { Faker::Number.number(digits: 1) }
    value { Faker::Number.number(digits: 1) }
    competition_id { 1 }
    user_id { 1 }
  end

  factory :competition do
    id { Faker::Number.number(digits: 1) }
    name { Faker::Name.name }
    modality_id { 1 }
    user_id { 2 }
  end
end
