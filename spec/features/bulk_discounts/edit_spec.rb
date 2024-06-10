require "rails_helper"

RSpec.describe "bulk discounts show page" do
    describe "as a merchant" do
        it "I see a link to edit the bulk discount" do
            merchant = Merchant.create!(name: "Amazon")
            bulk_discount = merchant.bulk_discounts.create!(percentage_discount: 0.1, quantity_threshold: 10)

            visit "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}"

            expect(page).to have_link("Edit")

            click_link("Edit")

            expect(current_path).to eq("/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/edit")

            expect(find_field('Percentage discount').value).to eq("10")
            expect(find_field('Quantity threshold').value).to eq("10")

            fill_in 'Percentage discount', with: 20
            fill_in 'Quantity threshold', with: 20

            click_button "Submit"

            expect(current_path).to eq("/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}")

            expect(page).to have_content("Discount Percentage: 20%")
            expect(page).to have_content("Quantity Threshold: 20")
        end
    end
end