require "rails_helper"

RSpec.describe "bulk discounts index page" do
    describe "as a merchant" do
        # US 1 part 2
        describe "when I visit the bulk discounts index page" do
            it "I can see all of my bulk discounts including their percentage discount and quantity thresholds" do
                merchant = Merchant.create!(name: "Amazon")
                bulk_discount_1 = merchant.bulk_discounts.create!(percentage_discount: 0.1, quantity_threshold: 10)
                bulk_discount_2 = merchant.bulk_discounts.create!(percentage_discount: 0.2, quantity_threshold: 20)
                bulk_discount_3 = merchant.bulk_discounts.create!(percentage_discount: 0.3, quantity_threshold: 30)

                visit "/merchants/#{merchant.id}/bulk_discounts"

                within("#index_table") do
                expect(page).to have_content("Discount ID")
                expect(page).to have_content("Discount Percentage")
                expect(page).to have_content("Quantity Threshold")
                expect(page).to have_content("Links")
                expect(page).to have_content("#{(bulk_discount_1.percentage_discount * 100).to_i}%")
                expect(page).to have_content(bulk_discount_1.quantity_threshold)
                expect(page).to have_content("#{(bulk_discount_2.percentage_discount * 100).to_i}%")
                expect(page).to have_content(bulk_discount_2.quantity_threshold)
                expect(page).to have_content("#{(bulk_discount_3.percentage_discount * 100).to_i}%")
                expect(page).to have_content(bulk_discount_3.quantity_threshold)
                end
            end
            it "each bulk discount listed includes a link to its show page" do
                merchant = Merchant.create!(name: "Amazon")
                bulk_discount_1 = merchant.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 10)
                bulk_discount_2 = merchant.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 20)

                visit "/merchants/#{merchant.id}/bulk_discounts"
                
                within("#link_#{bulk_discount_1.id}") do
                expect(page).to have_link("View")

                click_link("View")
                expect(current_path).to eq("/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount_1.id}")
                expect(current_path).to_not eq("/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount_2.id}")
                end
            end
            # 3: Merchant Bulk Discount Delete

            # As a merchant
            # When I visit my bulk discounts index
            # Then next to each bulk discount I see a button to delete it
            # When I click this button
            # Then I am redirected back to the bulk discounts index page
            # And I no longer see the discount listed
            it "each bulk discount listed includes a button to delete it" do
                merchant = Merchant.create!(name: "Amazon")
                bulk_discount_1 = merchant.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 10)
                bulk_discount_2 = merchant.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 20)

                visit "/merchants/#{merchant.id}/bulk_discounts"

                within("#link_#{bulk_discount_1.id}") do
                    expect(page).to have_button("Delete")

                    click_button("Delete")
                end

                expect(current_path).to eq("/merchants/#{merchant.id}/bulk_discounts")
                expect(page).to_not have_content("#{(bulk_discount_1.percentage_discount * 100).to_i}%")
                expect(page).to_not have_content(bulk_discount_1.quantity_threshold)
                expect(page).to have_content("#{(bulk_discount_2.percentage_discount * 100).to_i}%")
                expect(page).to have_content(bulk_discount_2.quantity_threshold)
            end
        end
    end
end