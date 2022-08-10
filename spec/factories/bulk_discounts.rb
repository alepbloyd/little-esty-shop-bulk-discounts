require 'faker'

FactoryBot.define do
  factory :bulk_discount do
    merchant_id {}
    percent_discount {}
    quantity_threshold {}
  end
end