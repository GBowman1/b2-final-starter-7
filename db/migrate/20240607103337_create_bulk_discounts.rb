class CreateBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bulk_discounts do |t|
      t.references :merchant, foreign_key: true
      t.float :percentage_discount
      t.integer :quantity_threshold

      t.timestamps
    end
  end
end
