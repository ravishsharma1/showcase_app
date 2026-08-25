class Order < ApplicationRecord
  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum :status, { pending: 0, paid: 1, shipped: 2, delivered: 3, cancelled: 4 }, default: :pending

  validates :total, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(created_at: :desc) }

  def formatted_total
    format("$%.2f", total)
  end
end
