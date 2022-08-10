require 'faker'

FactoryBot.define do
  factory :item do
    name { "#{[Faker::Adjective.positive,Faker::Adjective.negative].sample.titleize} #{Faker::Food.dish}" }
    description {
      [Faker::Quotes::Shakespeare.hamlet, Faker::Quotes::Shakespeare.as_you_like_it].sample
    }
    unit_price { rand(100..100_000)}
    merchant_id {}
    status { [0,1].sample }
  end
end