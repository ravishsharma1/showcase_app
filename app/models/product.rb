class Product < ApplicationRecord
  belongs_to :category
  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  validates :name, presence: true, length: { maximum: 120 }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[name description price category_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end

  def formatted_price
    format("$%.2f", price)
  end
end
