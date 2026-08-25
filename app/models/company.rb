class Company < ApplicationRecord
  belongs_to :user

  has_many :jobs, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
end
