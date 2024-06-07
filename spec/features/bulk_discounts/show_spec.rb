require "rails_helper"

RSpec.describe "bulk discounts show page" do
    describe "as a merchant" do
        it "I see the bulk discount's quantity threshold and percentage discount" do
            merchant = Merchant.create!(name: "Amazon")
            bulk_discount = merchant.bulk_discounts.create!(percentage_discount: 0.1, quantity_threshold: 10)

            visit "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}"

            within("#bulk_discount_info") do
                expect(page).to have_content("Quantity Threshold: #{bulk_discount.quantity_threshold}")
                expect(page).to have_content("Discount Percentage: #{(bulk_discount.percentage_discount * 100).to_i}%")
            end
        end
    end
end