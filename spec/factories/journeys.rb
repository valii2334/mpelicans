FactoryBot.define do
  factory :journey do
    title                   { FFaker::Name.name }
    description             { FFaker::Lorem.paragraph }
    start_plus_code         { FFaker::Random.rand }
    status                  { :not_started }
    access_type             { :private }
    accepts_recommendations { false }
    access_code             { nil }
  end
end
