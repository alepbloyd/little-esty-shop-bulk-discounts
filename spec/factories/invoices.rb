require 'faker'

FactoryBot.define do
  factory :invoice do
    customer_id {}
    status {[0,1,2].sample}
  end
end