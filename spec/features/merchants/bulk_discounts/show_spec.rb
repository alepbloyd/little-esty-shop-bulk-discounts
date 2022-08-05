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

  it 'has a link to edit the bulk discount' do
  
    merchant1 = Merchant.create!(name: "Snake Shop")

      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)
      bulk_discount2 = BulkDiscount.create!(percent_discount: 20, quantity_threshold: 10, merchant_id: merchant1.id)
      
      visit "/merchants/#{merchant1.id}/bulk_discounts/#{bulk_discount1.id}"

      click_on "Edit Discount"

      expect(current_path).to eq(edit_merchant_bulk_discount_path(bulk_discount1.merchant,bulk_discount1))
  end
end


# Merchant Bulk Discount Edit

# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount


# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated