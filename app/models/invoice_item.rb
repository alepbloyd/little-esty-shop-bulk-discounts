class InvoiceItem < ApplicationRecord
  enum status: {packaged: 0, pending: 1, shipped: 2}

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  def total_revenue
    quantity * unit_price
  end

  def potential_discounts
    self.bulk_discounts
  end

  def discounts_percent_desc
    self.potential_discounts
        .order(percent_discount: :desc)
  end

  def applicable_discount_quantity?(bulk_discount)
    self.quantity >= bulk_discount.quantity_threshold
  end

  def best_discount
    discounts_percent_desc.find {|discount| self.applicable_discount_quantity?(discount)}
  end

  def revenue_after_discount
    if self.best_discount.nil?
      self.total_revenue
    else
      (total_revenue * (1.0 - (best_discount.percent_discount / 100.0))).round
    end
  end

end

# get all the merchant's discounts, compare the quantity threshold against the quantity on this invoiceitem, then multiply the total_revenue by the corresponding perecent discount

#need to connect invoiceitem to bulk discounts, then figure out which (if any to apply)

#could make a join table for invoiceitem and bulkdiscount, and a row in that gets created if the discount is applied?

# find the discount to apply by iterating through the bulk discounts for the merchant?