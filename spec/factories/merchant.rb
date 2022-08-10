require 'faker'

FactoryBot.define do
  factory :merchant do
    name {"#{Faker::Hobby.activity.titleize} Shop"}
    status {[0,1].sample}
  end
end