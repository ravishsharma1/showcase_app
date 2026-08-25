class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2, maximum: 1000 }

  scope :recent, -> { order(created_at: :desc) }
end
