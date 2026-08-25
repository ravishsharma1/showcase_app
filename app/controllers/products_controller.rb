class ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category).recent
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
    @products = @products.limit(24)
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
  end
end
