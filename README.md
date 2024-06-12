## DB SCHEMA
<img width="1339" alt="Screenshot 2024-06-11 at 8 34 36 PM" src="https://github.com/GBowman1/b2-final-starter-7/assets/74687494/f94594cb-5f51-48b2-97a2-a32aefbed569">

## PROJECT INFO
"Little Esty Shop" is a group project that requires students to build a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices.

Heroku Admin url: https://final-little-shop-63a5d5f9bdaa.herokuapp.com/admin/dashboard <br>
Heroku Merchant Url: https://final-little-shop-63a5d5f9bdaa.herokuapp.com/merchants/1/dashboard

## Ideas for a potential contributor to work on/refactor next
1) Add Holidays
  - Holidays API
  
  As a merchant
  When I visit the discounts index page
  I see a section with a header of "Upcoming Holidays"
  In this section the name and date of the next 3 upcoming US holidays are listed.
  
  Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)

2) Create a Holiday Discount

  - As a merchant,
  when I visit the discounts index page,
  In the Holiday Discounts section, I see a `create discount` button next to each of the 3 upcoming holidays.
  When I click on the button I am taken to a new discount form that has the form fields auto populated with the following:
  
     Discount name: <name of holiday> discount
     Percentage Discount: 30
     Quantity Threshold: 2
  
  I can leave the information as is, or modify it before saving.
  I should be redirected to the discounts index page where I see the newly created discount added to the list of discounts.

3) View a Holiday Discount

  - As a merchant (if I have created a holiday discount for a specific holiday),
  when I visit the discount index page,
  within the `Upcoming Holidays` section I should not see the button to 'create a discount' next to that holiday,
  instead I should see a `view discount` link.
  When I click the link I am taken to the discount show page for that holiday discount.
