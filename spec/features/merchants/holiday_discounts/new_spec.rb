require 'rails_helper'

RSpec.describe 'merchant new holiday discount page' do

  it 'has pre-filled percent discount, quantity threshold, and holiday name fields, and reroutes to the discount index page where the new discount is shown' do
    merchant1 = Merchant.create!(name: "Snake Shop")

      bulk_discount1 = BulkDiscount.create!(percent_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)

    visit merchant_bulk_discounts_path(merchant1.id)

    within "#upcoming-holiday-1" do
      click_on "New Discount"
    end

    expect(current_path).to eq(new_merchant_holiday_discount_path(merchant1))

    expect(page).to have_content("Discount Name: Labor Day Discount")
    expect(page).to have_field(:percent_discount, :with => 30)
    expect(page).to have_field(:quantity_threshold, :with => 2)

    click_on "Submit"

    expect(current_path).to eq(merchant_bulk_discounts_path(merchant1.id))

    within "#holiday-discount-list" do
      expect(page).to have_content("Labor Day Discount")
      expect(page).to have_content("Percent Discount: 30")
      expect(page).to have_content("Quantity Threshold: 2")
    end
  end
end

# Create a Holiday Discount

# As a merchant,
# when I visit the discounts index page,
# In the Holiday Discounts section, I see a `create discount` button next to each of the 3 upcoming holidays.
# When I click on the button I am taken to a new discount form that has the form fields auto populated with the following:

# Discount name: <name of holiday> discount
# Percentage Discount: 30
# Quantity Threshold: 2

# I can leave the information as is, or modify it before saving.
# I should be redirected to the discounts index page where I see the newly created discount added to the list of discounts.