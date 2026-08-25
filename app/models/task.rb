class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum :status, { todo: 0, in_progress: 1, done: 2 }, default: :todo
  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }, default: :medium

  validates :title, presence: true, length: { maximum: 120 }

  scope :recent, -> { order(created_at: :desc) }
  scope :overdue, -> { where("due_date < ?", Date.today).where.not(status: :done) }
end
