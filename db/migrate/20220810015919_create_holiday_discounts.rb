class CreateHolidayDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :holiday_discounts do |t|
      t.string :holiday_name
      t.integer :percent_discount, default: 30
      t.integer :quantity_threshold, default: 2
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
