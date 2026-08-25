class Job < ApplicationRecord
  belongs_to :company

  has_many :job_applications, dependent: :destroy
  has_many :applicants, through: :job_applications, source: :user

  enum :status, { draft: 0, published: 1, closed: 2 }, default: :draft
  enum :employment_type, { full_time: 0, part_time: 1, contract: 2, freelance: 3, internship: 4 }, default: :full_time

  validates :title, presence: true, length: { maximum: 120 }
  validates :description, presence: true
  validates :salary_min, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :salary_max, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  scope :published, -> { where(status: :published) }
  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[title description location employment_type status salary_min salary_max company_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[company]
  end

  def salary_range
    return "Not specified" if salary_min.nil? && salary_max.nil?
    return "$#{salary_min}" if salary_max.nil?
    return "$#{salary_max}" if salary_min.nil?

    "$#{salary_min} - $#{salary_max}"
  end
end
