require "rails_helper"

RSpec.describe "Merchant Bulk Discount Create" do
    describe "As a merchant" do
        # US2
        it "I can create a new bulk discount and see it populated on the index" do
            merchant = Merchant.create!(name: "Amazon")

            visit merchant_bulk_discounts_path(merchant)

            click_link "Create New Bulk Discount"

            expect(current_path).to eq(new_merchant_bulk_discount_path(merchant))

            fill_in 'bulk_discount_percentage_discount', with: 15
            fill_in 'bulk_discount_quantity_threshold', with: 10

            click_button "Submit"

            expect(current_path).to eq(merchant_bulk_discounts_path(merchant))

            within("#index_table") do
                within("#discount") do
                    expect(page).to have_content("15%")
                end
                within("#quantity") do
                    expect(page).to have_content("10")
                end
            end
        end
    end
end