require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'After creation' do
    before :each do
      # Setup at least two products with different quantities, names, etc
      @initial_quantity = 20
      cat1 = Category.create!(name: 'Apparel')
      @product1 = Product.create!( name: Faker::Hipster.word,
                          description: Faker::Hipster.paragraph(3),
                          category_id: cat1.id,
                          quantity: @initial_quantity,
                          image: open_asset('apparel1.jpg'),
                          price: Faker::Number.decimal(2))
      @product2 = Product.create!( name: Faker::Hipster.word,
                          description: Faker::Hipster.paragraph(3),
                          category_id: cat1.id,
                          quantity: @initial_quantity,
                          image: open_asset('apparel1.jpg'),
                          price: Faker::Number.decimal(2))
      @product_quantity = 2
      # Setup at least one product that will NOT be in the order
      @product_out = Product.create!(name: Faker::Hipster.word,
                          description: Faker::Hipster.paragraph(3),
                          category_id: cat1.id,
                          quantity: @initial_quantity,
                          image: open_asset('apparel1.jpg'),
                          price: Faker::Number.decimal(2))

       @order = Order.new(
                    email: Faker::Internet.free_email,
                    total_cents: Faker::Number.decimal(2),
                    stripe_charge_id: Faker::Number.digit)
      @order.line_items.new(
                      product: @product1,
                      quantity: @product_quantity,
                      item_price: @product1.price,
                      total_price: @product1.price * @product_quantity)
      @order.line_items.new(
                      product: @product2,
                      quantity: @product_quantity,
                      item_price: @product2.price,
                      total_price: @product2.price * @product_quantity)
      @order.save!

      @product1.reload
      @product2.reload
      @product_out.reload

    end

    it 'deducts quantity from products based on their line item quantities' do
      expect(@product1.quantity).to eql(@initial_quantity - @product_quantity)
      expect(@product2.quantity).to eql(@initial_quantity - @product_quantity)

    end

    it 'does not deduct quantity from products that are not in the order' do
      expect(@product_out.quantity).to eql(@initial_quantity)
    end
  end
end

def open_asset(file_name)
  File.open(Rails.root.join('db', 'seed_assets', file_name))
end
