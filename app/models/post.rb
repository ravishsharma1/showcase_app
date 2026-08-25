class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 200 }
  validates :body, presence: true

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[title body published category_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category user]
  end
end
