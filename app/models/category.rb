class Category < ApplicationRecord
  has_many :products, dependent: :nullify
  has_many :posts, dependent: :nullify

  validates :name, presence: true, uniqueness: true, length: { maximum: 60 }
end
