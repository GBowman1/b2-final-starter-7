require 'rails_helper'

describe Merchant do
  describe "validations" do
    it { should validate_presence_of :name }
  end
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it {should have_many(:invoices).through(:invoice_items)}
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many :bulk_discounts }

  end

  describe "class methods" do
    before :each do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)
      @merchant4 = create(:merchant)
      @merchant5 = create(:merchant)
      @merchant6 = create(:merchant)

      @item1 = create(:item, merchant: @merchant1)
      @item2 = create(:item, merchant: @merchant2)
      @item3 = create(:item, merchant: @merchant2)
      @item7 = create(:item, merchant: @merchant3)
      @item4 = create(:item, merchant: @merchant4)
      @item5 = create(:item, merchant: @merchant5)
      @item6 = create(:item, merchant: @merchant6)

      @customer1 = create(:customer)
      @customer2 = create(:customer)

      @invoice1 = create(:invoice, customer: @customer1, status: 2)
      @invoice2 = create(:invoice, customer: @customer2, status: 2)
      @invoice3 = create(:invoice, customer: @customer2, status: 2)
      @invoice4 = create(:invoice, customer: @customer1, status: 2)
      @invoice5 = create(:invoice, customer: @customer2, status: 2)
      @invoice6 = create(:invoice, customer: @customer1, status: 2)
      @invoice7 = create(:invoice, customer: @customer2, status: 2)
      @invoice8 = create(:invoice, customer: @customer2, status: 2)

      InvoiceItem.create!(invoice: @invoice1, item: @item1, unit_price: 100, quantity: 5, status: 1) # merchant 1: 500
      InvoiceItem.create!(invoice: @invoice2, item: @item2, unit_price: 100, quantity: 1, status: 1)
      InvoiceItem.create!(invoice: @invoice3, item: @item3, unit_price: 500, quantity: 1, status: 1) # merchant 2: 600
      InvoiceItem.create!(invoice: @invoice7, item: @item7, unit_price: 500, quantity: 2, status: 1) # merchant 3: 1000
      InvoiceItem.create!(invoice: @invoice5, item: @item4, unit_price: 300, quantity: 4, status: 1) # merchant 4: 1200
      InvoiceItem.create!(invoice: @invoice6, item: @item5, unit_price: 500, quantity: 3, status: 1) # merchant 5: 1500
      InvoiceItem.create!(invoice: @invoice8, item: @item6, unit_price: 500, quantity: 5, status: 1) # merchant 6: 2500
      InvoiceItem.create!(invoice: @invoice4, item: @item1, unit_price: 500, quantity: 10, status: 1) # merchant 1 (failed transaction): 5000

      create(:transaction, invoice: @invoice1, result: 1)
      create(:transaction, invoice: @invoice2, result: 1)
      create(:transaction, invoice: @invoice3, result: 1)
      create(:transaction, invoice: @invoice4, result: 0) # transaction fails for merchant 1
      create(:transaction, invoice: @invoice5, result: 1) 
      create(:transaction, invoice: @invoice6, result: 1) 
      create(:transaction, invoice: @invoice7, result: 1) 
      create(:transaction, invoice: @invoice8, result: 1) 

    end

    it 'top_merchants' do
      expect(Merchant.top_merchants).to eq([@merchant6, @merchant5, @merchant4, @merchant3, @merchant2])
    end
  end

  describe "instance methods" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-26 14:54:09")
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, created_at: "2012-03-05 14:54:09")
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2, created_at: "2012-03-04 14:54:09")
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2, created_at: "2012-03-29 14:54:09")
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1, created_at: "2012-03-29 14:54:09")
      @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2, created_at: "2012-03-27 14:54:09")

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0, created_at: "2012-03-27 14:54:09")
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2, created_at: "2012-03-28 14:54:09")
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-03-30 14:54:09")
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-01 14:54:09")
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1, created_at: "2012-04-02 14:54:09")
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1, created_at: "2012-04-03 14:54:09")
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-05 14:54:09")

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)

    end
    it "can list items ready to ship" do
      expect(@merchant1.ordered_items_to_ship).to eq([@ii_1, @ii_2, @ii_4, @ii_6, @ii_7, @ii_8, @ii_9, @ii_10])
    end

    it "shows a list of favorite customers" do
      actual = @merchant1.favorite_customers.map do |customer|
        customer[:first_name]
      end
      expect(actual).to eq([@customer_1.first_name, @customer_2.first_name, @customer_3.first_name, @customer_4.first_name, @customer_6.first_name])
    end

    it "top_5_items" do
      expect(@merchant1.top_5_items).to eq([@item_1, @item_2, @item_3, @item_8, @item_4])
    end

    it "best_day" do
      expect(@merchant1.best_day).to eq(@invoice_8.created_at.to_date)
    end

    it "enabled_items" do
      expect(@merchant1.enabled_items).to eq([@item_1])
      expect(@merchant2.enabled_items).to eq([])
    end

    it "disabled_items" do 
      expect(@merchant1.disabled_items).to eq([@item_2, @item_3, @item_4, @item_7, @item_8])
      expect(@merchant2.disabled_items).to eq([@item_5, @item_6])
    end
  end
end
