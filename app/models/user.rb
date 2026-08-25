class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Roles: 0 = user (freelancer), 1 = client (employer), 2 = admin
  enum :role, { user: 0, client: 1, admin: 2 }, default: :user

  validates :name, presence: true

  # Companies owned by this user (client role)
  has_many :companies, dependent: :destroy
  has_many :jobs, through: :companies

  # Freelancer side
  has_many :job_applications, dependent: :destroy
  has_many :applied_jobs, through: :job_applications, source: :job

  # Commerce
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_items, through: :orders

  # Blog
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Projects
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  def admin?
    role == "admin"
  end

  def client?
    role == "client"
  end
end
