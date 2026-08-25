class Project < ApplicationRecord
  belongs_to :user

  has_many :tasks, dependent: :destroy

  enum :status, { planning: 0, in_progress: 1, on_hold: 2, completed: 3, cancelled: 4 }, default: :planning

  validates :title, presence: true, length: { maximum: 120 }
  validates :description, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def progress_percentage
    return 0 if tasks.empty?

    completed = tasks.where(status: :done).count
    ((completed.to_f / tasks.count) * 100).round
  end
end
