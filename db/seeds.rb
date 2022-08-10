# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'factory_bot_rails'
include FactoryBot::Syntax::Methods


@bulk_discounts = [] #
@holiday_discounts = []
@customers = [] #
@invoice_items = [] #
@invoices = [] #
@items = [] #
@transactions = [] #
@merchants = [] #



(1..1000).each do
  @customers << FactoryBot.create(:customer)
end

(1..100).each do
  @merchants << FactoryBot.create(:merchant)
end

(1..1000).each do
  @items << FactoryBot.create(:item, merchant_id: @merchants.sample.id)
end

(1..1000).each do
  @invoices << FactoryBot.create(:invoice, customer_id: @customers.sample.id)
end

(1..2000).each do
  @invoice_items << FactoryBot.create(:invoice_item, invoice_id: @invoices.sample.id, item_id: @items.sample.id)
end

(1..1000).each do
  @transactions << FactoryBot.create(:transaction, invoice_id: @invoices.sample.id)
end

@merchants.each do |merchant|
  @bulk_discounts << FactoryBot.create(:bulk_discount, merchant_id: merchant.id, percent_discount: 10, quantity_threshold: 5)

  @bulk_discounts << FactoryBot.create(:bulk_discount, merchant_id: merchant.id, percent_discount: 20, quantity_threshold: 10)

  @bulk_discounts << FactoryBot.create(:bulk_discount, merchant_id: merchant.id, percent_discount: 50, quantity_threshold: 30)
end

@merchants.each do |merchant|
  @holiday_discounts << HolidayDiscount.create(holiday_name: "Christmas", percent_discount: 30, quantity_threshold: 2, merchant_id: merchant.id)git 
end