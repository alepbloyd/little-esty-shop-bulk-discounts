require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one :merchant }

  end
  describe 'instance methods' do

    it 'returns total_revenue' do

      merchant1 = Merchant.create!(name: "Snake Shop")

      customer = Customer.create!(first_name: "Alep", last_name: "Bloyd")

      item1_merchant1 = Item.create!(name: "Snake Pants", description: "It is just a sock.", unit_price: 400, merchant_id: merchant1.id)

      invoice1 = Invoice.create!(customer_id: customer.id, status: 2)

      invoiceitem1_item1_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 70, unit_price: 50, status: 0)

      expect(invoiceitem1_item1_invoice1.total_revenue).to eq(3500)
    end

    it 'returns potential bulk discounts' do
      merchant1 = Merchant.create!(name: "Snake Shop")
        bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 10, merchant_id: merchant1.id)
        bulk_discount2 = BulkDiscount.create!(percent_discount: 50, quantity_threshold: 50, merchant_id: merchant1.id)
        bulk_discount3 = BulkDiscount.create!(percent_discount: 90, quantity_threshold: 90, merchant_id: merchant1.id)

      customer = Customer.create!(first_name: "Alep", last_name: "Bloyd")

      item1_merchant1 = Item.create!(name: "Snake Pants", description: "It is just a sock.", unit_price: 400, merchant_id: merchant1.id)

      invoice1 = Invoice.create!(customer_id: customer.id, status: 2)

      invoiceitem1_item1_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 70, unit_price: 50, status: 0)

      expect(invoiceitem1_item1_invoice1.potential_discounts).to eq([bulk_discount1,bulk_discount2,bulk_discount3])
    end

    it 'returns bulk discounts sorted by highest percentage discounted' do
      merchant1 = Merchant.create!(name: "Snake Shop")
        bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 10, merchant_id: merchant1.id)
        bulk_discount2 = BulkDiscount.create!(percent_discount: 50, quantity_threshold: 50, merchant_id: merchant1.id)
        bulk_discount3 = BulkDiscount.create!(percent_discount: 90, quantity_threshold: 90, merchant_id: merchant1.id)

      customer = Customer.create!(first_name: "Alep", last_name: "Bloyd")

      item1_merchant1 = Item.create!(name: "Snake Pants", description: "It is just a sock.", unit_price: 400, merchant_id: merchant1.id)

      invoice1 = Invoice.create!(customer_id: customer.id, status: 2)

      invoiceitem1_item1_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 70, unit_price: 50, status: 0)

      expect(invoiceitem1_item1_invoice1.discounts_percent_desc).to eq([bulk_discount3,bulk_discount2,bulk_discount1])
    end

    it 'checks the applicability of a bulk discount' do
      merchant1 = Merchant.create!(name: "Snake Shop")
        bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 10, merchant_id: merchant1.id)
        bulk_discount2 = BulkDiscount.create!(percent_discount: 50, quantity_threshold: 50, merchant_id: merchant1.id)
        bulk_discount3 = BulkDiscount.create!(percent_discount: 90, quantity_threshold: 90, merchant_id: merchant1.id)

      customer = Customer.create!(first_name: "Alep", last_name: "Bloyd")

      item1_merchant1 = Item.create!(name: "Snake Pants", description: "It is just a sock.", unit_price: 400, merchant_id: merchant1.id)

      invoice1 = Invoice.create!(customer_id: customer.id, status: 2)

      invoiceitem1_item1_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 70, unit_price: 50, status: 0)

      expect(invoiceitem1_item1_invoice1.applicable_discount_quantity?(bulk_discount1)).to be true

      expect(invoiceitem1_item1_invoice1.applicable_discount_quantity?(bulk_discount2)).to be true

      expect(invoiceitem1_item1_invoice1.applicable_discount_quantity?(bulk_discount3)).to be false
    end

    it 'returns the best applicable discount' do
      # check the invoiceitem quantity against the quantity threshold

      merchant1 = Merchant.create!(name: "Snake Shop")
        bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 10, merchant_id: merchant1.id)
        bulk_discount2 = BulkDiscount.create!(percent_discount: 50, quantity_threshold: 50, merchant_id: merchant1.id)
        bulk_discount3 = BulkDiscount.create!(percent_discount: 90, quantity_threshold: 90, merchant_id: merchant1.id)

      customer = Customer.create!(first_name: "Alep", last_name: "Bloyd")

      item1_merchant1 = Item.create!(name: "Snake Pants", description: "It is just a sock.", unit_price: 400, merchant_id: merchant1.id)

      invoice1 = Invoice.create!(customer_id: customer.id, status: 2)

      invoiceitem1_item1_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 70, unit_price: 50, status: 1)

      expect(invoiceitem1_item1_invoice1.best_discount).to eq(bulk_discount2)
    end
  end
end