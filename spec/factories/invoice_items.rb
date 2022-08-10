require 'faker'

FactoryBot.define do
  factory :invoice_item do
    item_id {}
    invoice_id {}
    quantity { rand(1..50) }
    unit_price { rand(100..100_000)}
    status { [0,1,2].sample }
  end
end