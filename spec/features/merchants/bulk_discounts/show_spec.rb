require 'rails_helper'

RSpec.describe 'merchant bulk discount show page' do

  it 'displays the bulk discount\'s quantity threshold and percentage discount' do
    merchant1 = Merchant.create!(name: "Snake Shop")

      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)
      bulk_discount2 = BulkDiscount.create!(percent_discount: 20, quantity_threshold: 10, merchant_id: merchant1.id)

    visit "/merchants/#{merchant1.id}/bulk_discounts/#{bulk_discount1.id}"

    expect(page).to have_content("Percent Discount: 10%")
    expect(page).to have_content("Quantity Threshold: 5")

    expect(page).to_not have_content("Percent Discount: 20%")
    expect(page).to_not have_content("Quantity Threshold: 10")
  end

end
