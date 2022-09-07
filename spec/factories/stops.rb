FactoryBot.define do
  factory :stop do
    title       { FFaker::Name.name }
    description { FFaker::Lorem.paragraph }
    plus_code   { FFaker::Random.rand }
    journey
  end
end
