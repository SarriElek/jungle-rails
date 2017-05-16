class Order < ActiveRecord::Base

  belongs_to :user
  has_many :line_items

  monetize :total_cents, numericality: true

  validates :stripe_charge_id, presence: true

  after_create :update_product_quantities

  private

  def update_product_quantities
    line_items.each {
      |item|
       item.product.update(quantity: )
       }
  end

end
