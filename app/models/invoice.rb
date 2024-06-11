class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    discounts = invoice_items.joins(item: :bulk_discounts)
                  .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
                  .select('invoice_items.id, MAX(bulk_discounts.percentage_discount) as biggest_discount')
                  .group('invoice_items.id')
                  # .sum('(invoice_items.unit_price * invoice_items.quantity) * biggest_discount')

    discount_sum = InvoiceItem.from("invoice_items, (#{discounts.to_sql}) as discounts")
                              .where('invoice_items.id = discounts.id')
                              .sum('(invoice_items.unit_price * invoice_items.quantity) * biggest_discount')

    total_revenue - discount_sum
  end

  def total_revenue_merchant(merchant)
  invoice_items.joins(:item)
                .where(items: { merchant_id: merchant.id })
                .sum("invoice_items.unit_price * invoice_items.quantity")
end

  def discounted_revenue_merchant(merchant)
    discounts = invoice_items.joins(item: :bulk_discounts)
                  .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
                  .where(items: { merchant_id: merchant.id })
                  .select('invoice_items.id, MAX(bulk_discounts.percentage_discount) as biggest_discount')
                  .group('invoice_items.id')

    discount_sum = InvoiceItem.from("invoice_items, (#{discounts.to_sql}) as discounts")
                              .where('invoice_items.id = discounts.id')
                              .sum('(invoice_items.unit_price * invoice_items.quantity) * biggest_discount')

    total_revenue_merchant(merchant) - discount_sum
  end
end
