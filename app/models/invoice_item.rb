class InvoiceItem < ApplicationRecord
  enum status: {packaged: 0, pending: 1, shipped: 2}

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  def total_revenue
    quantity * unit_price
  end

  def applied_discount
    # get all the merchant's discounts, compare the quantity threshold against the quantity on this invoiceitem, then multiply the total_revenue by the corresponding perecent discount

    #need to connect invoiceitem to bulk discounts, then figure out which (if any to apply)

    #could make a join table for invoiceitem and bulkdiscount, and a row in that gets created if the discount is applied?
  end
end

# find the discount to apply by iterating through the bulk discounts for the merchant?