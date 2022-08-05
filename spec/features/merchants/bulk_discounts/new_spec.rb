require 'rails_helper'

RSpec.describe 'merchant new bulk discount page' do

  it 'has a form to create a new bulk discount, and when filled in with valid data, redirects to the bulk discount index and shows the new bulk discount' do
    merchant1 = Merchant.create!(name: "Snake Shop")

    visit new_merchant_bulk_discount_path(merchant1)

    fill_in "Percent Discount", with: 75

    fill_in "Quantity Threshold", with: 30

    click_on "Submit"

    expect(current_path).to eq(merchant_bulk_discounts_path(merchant1))

    expect(page).to have_content("Percent Discount: 75%")
    expect(page).to have_content("Quantity Threshold: 30")
    expect(page).to have_content("New discount created!")
  end

  it 'rejects input if percent_discount is left blank' do
    merchant1 = Merchant.create!(name: "Snake Shop")

    visit new_merchant_bulk_discount_path(merchant1)

    fill_in "Quantity Threshold", with: 30

    click_on "Submit"

    expect(current_path).to eq(new_merchant_bulk_discount_path(merchant1))

    expect(page).to have_content("Error - please complete all fields")
  end

  it 'rejects input if quantity_threshold is left blank' do
    merchant1 = Merchant.create!(name: "Snake Shop")

    visit new_merchant_bulk_discount_path(merchant1)

    fill_in "Percent Discount", with: 75

    click_on "Submit"

    expect(current_path).to eq(new_merchant_bulk_discount_path(merchant1))

    expect(page).to have_content("Error - please complete all fields")
  end

end