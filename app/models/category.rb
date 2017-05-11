class Category < ActiveRecord::Base

  has_many :products

  before_destroy :check_product_number

  private

  def check_product_number
    if products.any?
        errors.add(:base, "You can't delete a category assigned to a product")
        throw :abort
    end
  end

end
