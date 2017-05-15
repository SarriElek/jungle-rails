require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:each) do
    @product = Product.new
    @product.name = Faker::Name.name
    @product.price_cents = Faker::Number.decimal(2)
    @product.quantity = Faker::Number.number(3)
    @product.category = Category.new
  end
  describe 'Validations' do
    it 'should run all validations' do
      expect(@product.valid?).to be_truthy
    end
    it 'should validate presence of name' do
      @product.name = nil
      @product.valid?
      expect(@product.errors[:name]).to include('can\'t be blank')
    end
    it 'should validate presence of price' do
      @product.price_cents = nil
      @product.valid?
      expect(@product.errors[:price_cents]).to include('is not a number')
    end
    it 'should validate presence of quantity' do
      @product.quantity = nil
      @product.valid?
      expect(@product.errors[:quantity]).to include('can\'t be blank')
    end
    it 'should validate presence of category' do
      @product.category = nil
      @product.valid?
      expect(@product.errors[:category]).to include('can\'t be blank')
    end
  end
end
