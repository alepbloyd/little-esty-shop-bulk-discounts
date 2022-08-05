require 'rails_helper'

RSpec.describe 'merchant bulk discount index' do
  it 'displays all of the merchant\'s bulk discounts, their percentages, and quantity thresholds' do
    merchant1 = Merchant.create!(name: "Snake Shop")

      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)
      bulk_discount2 = BulkDiscount.create!(percent_discount: 20, quantity_threshold: 10, merchant_id: merchant1.id)
      bulk_discount3 = BulkDiscount.create!(percent_discount: 30, quantity_threshold: 15, merchant_id: merchant1.id)
      bulk_discount4 = BulkDiscount.create!(percent_discount: 40, quantity_threshold: 20, merchant_id: merchant1.id)
    
    merchant2 = Merchant.create!(name: "Fish Foods")
      bulk_discount5 = BulkDiscount.create!(percent_discount: 80, quantity_threshold: 70, merchant_id: merchant2.id)

    visit merchant_bulk_discounts_path(merchant1.id)

    within "#bulk-discount-#{bulk_discount1.id}" do
      expect(page).to have_content("Percent Discount: 10%")
      expect(page).to have_content("Quantity Threshold: 5")
    end
    within "#bulk-discount-#{bulk_discount2.id}" do
      expect(page).to have_content("Percent Discount: 20%")
      expect(page).to have_content("Quantity Threshold: 10")
    end
    within "#bulk-discount-#{bulk_discount3.id}" do
      expect(page).to have_content("Percent Discount: 30%")
      expect(page).to have_content("Quantity Threshold: 15")
    end
    within "#bulk-discount-#{bulk_discount4.id}" do
      expect(page).to have_content("Percent Discount: 40%")
      expect(page).to have_content("Quantity Threshold: 20")
    end

    expect(page).to_not have_content("Percent: Discount: 80%")
    expect(page).to_not have_content("Quantity Threshold: 70")
  end

  it 'has link next to each bulk discount that takes user to the bulk discount\'s show page' do
    merchant1 = Merchant.create!(name: "Snake Shop")

      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)
      bulk_discount2 = BulkDiscount.create!(percent_discount: 20, quantity_threshold: 10, merchant_id: merchant1.id)
      bulk_discount3 = BulkDiscount.create!(percent_discount: 30, quantity_threshold: 15, merchant_id: merchant1.id)

    visit merchant_bulk_discounts_path(merchant1.id)

    within "#bulk-discount-#{bulk_discount1.id}" do
      click_on "View Bulk Discount Details"
    end

    expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/#{bulk_discount1.id}")
  end
end