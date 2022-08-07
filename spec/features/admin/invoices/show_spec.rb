require 'rails_helper'

RSpec.describe 'admin invoices show page' do
  before :each do
    @pokemart = Merchant.create!(name: 'PokeMart')
    @potion = @pokemart.items.create!(name: 'Potion', description: 'Recovers 10 HP', unit_price: 2)
    @super_potion = @pokemart.items.create!(name: 'Super Potion', description: 'Recovers 25 HP', unit_price: 5)
    @ultra_ball = @pokemart.items.create!(name: 'Ultra Ball', description: 'High chance of catching a Pokemon',
                                          unit_price: 8)

    @trainer_red = Customer.create!(first_name: 'Red', last_name: 'Trainer')
    @invoice1 = @trainer_red.invoices.create!(status: 2, created_at: '2022-07-26 01:08:32 UTC')
    @invoice2 = @trainer_red.invoices.create!(status: 2)
    @invoice_item1 = InvoiceItem.create!(invoice: @invoice1, item: @ultra_ball, quantity: 2, unit_price: 8,
                                         status: 0)
    @invoice_item2 = InvoiceItem.create!(invoice: @invoice1, item: @super_potion, quantity: 2, unit_price: 5,
                                         status: 0)
    @invoice1.transactions.create!(credit_card_number: 3_395_123_433_951_234, result: 1)
    @invoice1.transactions.create!(credit_card_number: 3_395_123_433_951_234, result: 1)
    @invoice2.transactions.create!(credit_card_number: 3_395_123_433_951_234, result: 1)
    @invoice2.transactions.create!(credit_card_number: 3_395_123_433_951_234, result: 1)

    @pokegarden = Merchant.create!(name: 'PokeGarden')
    @razz_berry = @pokegarden.items.create!(name: 'Razz Berry',
                                            description: 'Feed this to a Pokémon, and it will be easier to catch on your next throw.', unit_price: 2)
    @nanab_berry = @pokegarden.items.create!(name: 'Nanab Berry',
                                             description: 'Feed this to a Pokémon to calm it down, making it less erratic.', unit_price: 5)
    @pinap_berry = @pokegarden.items.create!(name: 'Pinap Berry',
                                             description: 'Feed this to a Pokémon to make it drop more Candy.', unit_price: 8)

    @trainer_blue = Customer.create!(first_name: 'Blue', last_name: 'Trainer')
    @invoice3 = @trainer_blue.invoices.create!(status: 2)
    @invoice4 = @trainer_blue.invoices.create!(status: 2)
    @invoice_item3 = InvoiceItem.create!(invoice: @invoice3, item: @razz_berry, quantity: 2, unit_price: 8,
                                         status: 0)
    @invoice_item4 = InvoiceItem.create!(invoice: @invoice4, item: @pinap_berry, quantity: 2, unit_price: 5,
                                         status: 0)
    @invoice3.transactions.create!(credit_card_number: 1_195_123_411_951_234, result: 1)
    @invoice3.transactions.create!(credit_card_number: 1_195_123_411_951_234, result: 1)
    @invoice4.transactions.create!(credit_card_number: 1_195_123_411_951_234, result: 1)
    @invoice4.transactions.create!(credit_card_number: 1_195_123_411_951_234, result: 1)
  end

  it 'displays invoice attributes' do
    visit "/admin/invoices/#{@invoice1.id}"

    within '#invoice-attributes' do
      expect(page).to have_content("Invoice ID: #{@invoice1.id}")
      expect(page).to have_content("Invoice Status: #{@invoice1.status}")
      expect(page).to have_content('Created At: Tuesday, July 26, 2022')
      expect(page).to have_content('Customer Name: Red Trainer')
    end
  end

  it 'displays invoice item information' do
    visit "/admin/invoices/#{@invoice1.id}"

    within "#invoice-item-#{@invoice_item1.id}" do
      expect(page).to have_content("Item Name: #{@invoice_item1.item.name}")
      expect(page).to have_content("Quantity: #{@invoice_item1.quantity}")
      expect(page).to have_content("Price: $8.00")
      expect(page).to have_content("Status: #{@invoice_item1.status}")
    end

    within "#invoice-item-#{@invoice_item2.id}" do
      expect(page).to have_content("Item Name: #{@invoice_item2.item.name}")
      expect(page).to have_content("Quantity: #{@invoice_item2.quantity}")
      expect(page).to have_content("Price: $5.00")
      expect(page).to have_content("Status: #{@invoice_item2.status}")
    end
  end

  it 'displays invoice total revenue' do
    visit "/admin/invoices/#{@invoice1.id}"

    within '#total-revenue' do
      expect(page).to have_content('Total Revenue: $26.00')
    end
  end

  it 'has a select field to update invoice status' do
    visit "/admin/invoices/#{@invoice1.id}"

    within '#update-status' do
      expect(page).to have_content('completed')

      select 'cancelled', from: 'Status'
      click_on 'Update Status'

      expect(page).to have_content('cancelled')
    end
  end

  it 'displays the total revenue from this invoice (not including discounts) and the total discounted revenue from this invoice (which includes bulk discounts in the calculation' do
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

      transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: 2222_3333_4444_5555, credit_card_expiration_date: "05-19-1992", result: 1)

    visit "/admin/invoices/#{invoice1.id}"

    expect(page).to have_content("Revenue After Discounts: $285.00")
  end
end