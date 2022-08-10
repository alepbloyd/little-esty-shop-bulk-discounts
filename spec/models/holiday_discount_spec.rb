require 'rails_helper'

RSpec.describe HolidayDiscount do
  describe 'relationships' do
    it { should belong_to :merchant}
    it { should have_many(:items).through(:merchant)}
    it { should have_many(:invoice_items).through(:items)}
  end
end