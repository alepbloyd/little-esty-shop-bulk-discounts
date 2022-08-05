require 'rails_helper'

RSpec.describe 'merchant bulk discount edit page' do
  it 'is pre-filled with the current discount attributes' do
    merchant1 = Merchant.create!(name: "Snake Shop")

      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)
      bulk_discount2 = BulkDiscount.create!(percent_discount: 20, quantity_threshold: 10, merchant_id: merchant1.id)

      visit edit_merchant_bulk_discount_path(bulk_discount1.merchant,bulk_discount1)

      expect(page).to have_field("Percent Discount", with: 10)
      expect(page).to have_field("Quantity Threshold", with: 5)
  end

  it 'when information is changed and submitted, redirects to the discount\'s show page and see the updated information' do
    merchant1 = Merchant.create!(name: "Snake Shop")

      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)

    visit edit_merchant_bulk_discount_path(bulk_discount1.merchant,bulk_discount1)

    fill_in "Percent Discount", with: 90
    fill_in "Quantity Threshold", with: 30

    click_on "Submit"

    expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/#{bulk_discount1.id}")

    expect(page).to have_content("Percent Discount: 90%")
    expect(page).to have_content("Quantity Threshold: 30")
  end

  it 'rejects update if discount is over 100' do
    merchant1 = Merchant.create!(name: "Snake Shop")

      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)

    visit edit_merchant_bulk_discount_path(bulk_discount1.merchant,bulk_discount1)

    fill_in "Percent Discount", with: 110

    click_on "Submit"

    expect(current_path).to eq(edit_merchant_bulk_discount_path(bulk_discount1.merchant,bulk_discount1))

    expect(page).to have_content("Please enter a number under 100 for percentage")
  end
end
