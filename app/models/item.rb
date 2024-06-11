class Item < ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :unit_price,
                        :merchant_id

  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant
  has_many :bulk_discounts, through: :merchant

  enum status: [:disabled, :enabled]

  def best_day
    invoices
    .joins(:transactions)
    .where("transactions.result = 1")
    .where("invoices.status = 2")
    .select("CAST(invoices.created_at as date) as invoice_date, sum(invoice_items.unit_price * invoice_items.quantity) as total_rev")
    .group("invoice_date")
    .order("total_rev desc, invoice_date desc")
    .limit(1)
    .first&.invoice_date&.to_date

  end
end
