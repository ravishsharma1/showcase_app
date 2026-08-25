Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  # Dashboard
  get "dashboard", to: "dashboard#index"

  # Jobs (job board)
  resources :jobs do
    resources :job_applications, only: %i[create destroy], shallow: true
  end

  # Companies
  resources :companies

  # Commerce
  resources :products, only: %i[index show]
  resources :orders, only: %i[index show create]

  # Blog
  resources :posts, only: %i[index show]
  resources :comments, only: %i[create destroy]

  # Projects
  resources :projects do
    resources :tasks, shallow: true
  end

  # Admin
  namespace :admin do
    get "dashboard", to: "dashboard#show"
    resources :users, only: %i[index update]
    resources :categories
  end
end
