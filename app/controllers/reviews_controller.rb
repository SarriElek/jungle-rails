class ReviewsController < ApplicationController

  before_filter :check_logged_user

  def create
    product = Product.find(params[:product_id])
    review = product.reviews.new(review_params)
    review.user = current_user
    if review.save
      redirect_to product, notice: 'Review was successfully created.'
    else
      redirect_to product, notice: 'An error happened creating the review.'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to product_url(@review.product), notice: 'Review was successfully destroyed.'
  end

  private

  def review_params
    params.require(:review).permit(:rating, :description)
  end

  def check_logged_user
    unless current_user.present?
      flash[:error] = "You must be logged in to create/destroy reviews"
      redirect_to login_url
    end
  end

end
