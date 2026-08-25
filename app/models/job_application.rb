class JobApplication < ApplicationRecord
  belongs_to :job
  belongs_to :user

  enum :status, { pending: 0, reviewed: 1, shortlisted: 2, rejected: 3, hired: 4 }, default: :pending

  validates :cover_letter, presence: true, length: { minimum: 20 }
  validates :job_id, uniqueness: { scope: :user_id, message: "You have already applied to this job" }
end
