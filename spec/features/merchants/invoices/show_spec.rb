require 'rails_helper'

RSpec.describe 'merchant_invoices show page' do
  it 'shows invoice details: id, status,customer name, created_at in Monday, July 18, 2019 format' do
      merch1 = Merchant.create!(name: 'Needful Things Imports')

      customer1 = Customer.create!(first_name: 'Bob', last_name: 'Schneider')
      customer2 = Customer.create!(first_name: 'Veruca', last_name: 'Salt')

      item1 = merch1.items.create!(name: 'Phoenix Feather Wand', description: 'Ergonomic grip', unit_price: 20)
      item2 = merch1.items.create!(name: 'Harmonica', description: 'Makes pretty noise', unit_price: 6)

      invoice1 = customer1.invoices.create!(status: 1)
      invoice2 = customer2.invoices.create!(status: 1)

      invoice_item1 = InvoiceItem.create!(invoice: invoice1, item: item2, quantity: 1, unit_price: 6, status: 1)
      invoice_item2 = InvoiceItem.create!(invoice: invoice2, item: item1, quantity: 1, unit_price: 20, status: 1)

      visit merchant_invoice_path(merch1.id, invoice1.id)

      within '#invoice-attributes' do
        expect(page).to have_content("#{invoice1.status.titleize}")
        expect(page).to have_content("#{invoice1.formatted_date}")
        expect(page).to_not have_content("#{invoice2.id}")
      end

      within "#customer-attributes" do
        expect(page).to have_content("#{invoice1.customer_name}")
      end
  end

  it 'displays items within invoice with their name, qty, price, and status' do
      merch1 = Merchant.create!(name: 'Needful Things Imports')

      customer1 = Customer.create!(first_name: 'Bob', last_name: 'Schneider')
      customer2 = Customer.create!(first_name: 'Veruca', last_name: 'Salt')

      item1 = merch1.items.create!(name: 'Phoenix Feather Wand', description: 'Ergonomic grip', unit_price: 20)
      item2 = merch1.items.create!(name: 'Harmonica', description: 'Makes pretty noise', unit_price: 6)

      invoice1 = customer1.invoices.create!(status: 1)
      invoice2 = customer2.invoices.create!(status: 1)

      invoice_item1 = InvoiceItem.create!(invoice: invoice1, item: item2, quantity: 1, unit_price: 6, status: 1)
      invoice_item2 = InvoiceItem.create!(invoice: invoice2, item: item1, quantity: 1, unit_price: 20, status: 1)

      visit merchant_invoice_path(merch1.id, invoice1.id)

      within "#invoice-item-table" do
        expect(page).to have_content("#{invoice_item1.item.name}")
        expect(page).to have_content("#{invoice_item1.quantity}")
        expect(page).to have_content("$6.00")
        expect(page).to have_content("#{invoice_item1.status.titleize}")
        expect(page).to_not have_content("#{invoice_item2.item.name}")
      end
  end

  it 'displays total revenue from all items on invoice' do
      merch1 = Merchant.create!(name: 'Needful Things Imports')

      customer1 = Customer.create!(first_name: 'Bob', last_name: 'Schneider')
      customer2 = Customer.create!(first_name: 'Veruca', last_name: 'Salt')

      item1 = merch1.items.create!(name: 'Phoenix Feather Wand', description: 'Ergonomic grip', unit_price: 20)
      item2 = merch1.items.create!(name: 'Harmonica', description: 'Makes pretty noise', unit_price: 6)
      item3 = merch1.items.create!(name: 'Bag of Holding', description: 'This bag has an interior space considerably larger than its outside dimensions, roughly 2 feet in diameter at the mouth and 4 feet deep.', unit_price: 10)
      item4 = merch1.items.create!(name: 'Ring of Resonance', description: 'A ring that resonates with the Ring of Flame Lord', unit_price: 15)
      item5 = merch1.items.create!(name: 'Phreeoni Card', description: 'HIT + 100', unit_price: 20)

      invoice1 = customer1.invoices.create!(status: 1)
      invoice2 = customer2.invoices.create!(status: 1)

      invoice_item1 = InvoiceItem.create!(invoice: invoice1, item: item1, quantity: 1, unit_price: 20, status: 1)
      invoice_item1 = InvoiceItem.create!(invoice: invoice1, item: item2, quantity: 2, unit_price: 6, status: 1)
      invoice_item1 = InvoiceItem.create!(invoice: invoice1, item: item3, quantity: 1, unit_price: 10, status: 1)
      invoice_item2 = InvoiceItem.create!(invoice: invoice2, item: item4, quantity: 2, unit_price: 15, status: 1)
      invoice_item2 = InvoiceItem.create!(invoice: invoice2, item: item5, quantity: 1, unit_price: 20, status: 1)

      visit merchant_invoice_path(merch1.id, invoice1.id)

      within "#total-revenue" do
        expect(page).to have_content("Total Pre-Discounts: $42.00")
        expect(page).to_not have_content("Total Pre-Discounts: $50.00")
      end
  end

  it 'displays form to update item status' do
      merch1 = Merchant.create!(name: 'Needful Things Imports')

      customer1 = Customer.create!(first_name: 'Bob', last_name: 'Schneider')
      customer2 = Customer.create!(first_name: 'Veruca', last_name: 'Salt')

      item1 = merch1.items.create!(name: 'Phoenix Feather Wand', description: 'Ergonomic grip', unit_price: 20)
      item2 = merch1.items.create!(name: 'Harmonica', description: 'Makes pretty noise', unit_price: 6)

      invoice1 = customer1.invoices.create!(status: 1)
      invoice2 = customer2.invoices.create!(status: 1)

      invoice_item1 = InvoiceItem.create!(invoice: invoice1, item: item2, quantity: 1, unit_price: 6, status: 1)
      invoice_item2 = InvoiceItem.create!(invoice: invoice2, item: item1, quantity: 1, unit_price: 20, status: 1)

      visit merchant_invoice_path(merch1.id, invoice1.id)

      within "#invoice-item-table" do
        expect(page).to have_content("#{invoice_item1.item.name}")
        expect(page).to_not have_content("#{invoice_item2.item.name}")
        expect(page).to have_content("Pending")
        select("Shipped", from: "Status")
        click_button "Update Item Status"
        expect(page).to have_content("Shipped")
      end
  end

  it 'displays the total revenue for the merchant from this invoice (not including discounts)' do
    merchant1 = Merchant.create!(name: "Snake Shop")

    customer = Customer.create!(first_name: "Alep", last_name: "Bloyd")

    item1_merchant1 = Item.create!(name: "Snake Pants", description: "It is just a sock.", unit_price: 400, merchant_id: merchant1.id)
    item2_merchant1 = Item.create!(name: "Stinky Bits", description: "Nondescript floaty chunks.", unit_price: 200, merchant_id: merchant1.id)
    item3_merchant1 = Item.create!(name: "Fur Ball", description: "Ew pretty nasty!", unit_price: 1000, merchant_id: merchant1.id)

    invoice1 = Invoice.create!(customer_id: customer.id, status: 2) # total == 135
      invoiceitem1_item1_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 5, unit_price: 10, status: 0) # 50
      invoiceitem2_item2_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 20, unit_price: 3, status: 0) # 60
      invoiceitem3_item3_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 5, unit_price: 5, status: 0) #25

      transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: 2222_3333_4444_5555, credit_card_expiration_date: "05-19-1992", result: 1) # successful

    visit merchant_invoice_path(merchant1.id, invoice1.id)


    expect(page).to have_content("Total Pre-Discounts: $135.00")

  end

  it 'displays the total revenue for the merchant from this invoice, including bulk discounts in the calculation' do
    merchant1 = Merchant.create!(name: "Snake Shop")
      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 10, merchant_id: merchant1.id)
      bulk_discount2 = BulkDiscount.create!(percent_discount: 50, quantity_threshold: 50, merchant_id: merchant1.id)
      bulk_discount3 = BulkDiscount.create!(percent_discount: 90, quantity_threshold: 90, merchant_id: merchant1.id)

    customer = Customer.create!(first_name: "Alep", last_name: "Bloyd")

    item1_merchant1 = Item.create!(name: "Snake Pants", description: "It is just a sock.", unit_price: 400, merchant_id: merchant1.id)
    item2_merchant1 = Item.create!(name: "Stinky Bits", description: "Nondescript floaty chunks.", unit_price: 200, merchant_id: merchant1.id)
    item3_merchant1 = Item.create!(name: "Fur Ball", description: "Ew pretty nasty!", unit_price: 1000, merchant_id: merchant1.id)

    invoice1 = Invoice.create!(customer_id: customer.id, status: 2) # 135 + 75 + 50
      invoiceitem1_item1_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 15, unit_price: 10, status: 0) # 150 - (150 * 0.1) == 135
      invoiceitem2_item2_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 50, unit_price: 3, status: 0) # 150 - (150 * 0.5) == 75
      invoiceitem3_item3_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 100, unit_price: 5, status: 0) # 500 - (500 * 0.9) == 50

      transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: 2222_3333_4444_5555, credit_card_expiration_date: "05-19-1992", result: 1) # successful
    
    visit merchant_invoice_path(merchant1.id, invoice1.id)

    within "#revenue-after-discounts" do
      expect(page).to have_content("After Discounts: $260.00")
    end
  end

  it 'has link next to each invoice item, taking user to the bulk discount that was applied (if any)' do
    merchant1 = Merchant.create!(name: "Snake Shop")
      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 10, merchant_id: merchant1.id)
      bulk_discount2 = BulkDiscount.create!(percent_discount: 50, quantity_threshold: 50, merchant_id: merchant1.id)
      bulk_discount3 = BulkDiscount.create!(percent_discount: 90, quantity_threshold: 90, merchant_id: merchant1.id)

    customer = Customer.create!(first_name: "Alep", last_name: "Bloyd")

    item1_merchant1 = Item.create!(name: "Snake Pants", description: "It is just a sock.", unit_price: 400, merchant_id: merchant1.id)
    item2_merchant1 = Item.create!(name: "Stinky Bits", description: "Nondescript floaty chunks.", unit_price: 200, merchant_id: merchant1.id)
    item3_merchant1 = Item.create!(name: "Fur Ball", description: "Ew pretty nasty!", unit_price: 1000, merchant_id: merchant1.id)
    item4_merchant1 = Item.create!(name: "Fur Ball", description: "Ew pretty nasty!", unit_price: 1000, merchant_id: merchant1.id)

    invoice1 = Invoice.create!(customer_id: customer.id, status: 2) # 135 + 75 + 50
      invoiceitem1_item1_invoice1 = InvoiceItem.create!(item_id: item1_merchant1.id, invoice_id: invoice1.id, quantity: 15, unit_price: 10, status: 1) # bulk_discount1
      invoiceitem2_item2_invoice1 = InvoiceItem.create!(item_id: item2_merchant1.id, invoice_id: invoice1.id, quantity: 50, unit_price: 3, status: 1) # bulk_discount2
      invoiceitem3_item3_invoice1 = InvoiceItem.create!(item_id: item3_merchant1.id, invoice_id: invoice1.id, quantity: 100, unit_price: 5, status: 1) # bulk_discount3
      invoiceitem4_item3_invoice1 = InvoiceItem.create!(item_id: item4_merchant1.id, invoice_id: invoice1.id, quantity: 5, unit_price: 5, status: 1) # NO BULK DISCOUNT

      transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: 2222_3333_4444_5555, credit_card_expiration_date: "05-19-1992", result: 1) # successful
      
    visit merchant_invoice_path(merchant1.id, invoice1.id)
    
    within "#invoice-item-#{invoiceitem1_item1_invoice1.id}" do
      expect(page).to have_content("Bulk Discount Applied")
      click_on "Bulk Discount Applied"
    end


    expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/#{bulk_discount1.id}")
  end

end