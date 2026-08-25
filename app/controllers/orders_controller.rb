class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.includes(:order_items).recent
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i.positive? ? params[:quantity].to_i : 1

    order = current_user.orders.create!(status: :pending, total: product.price * quantity)
    order.order_items.create!(product: product, quantity: quantity, price: product.price)

    redirect_to order, notice: "Order placed successfully."
  end
end
