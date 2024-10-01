Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }, path: "auth", path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "sign_up"
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :books

  # API Sections
  get "/api/v1/books" => "api#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"

  # Sideqiq Monitoring
  require "sidekiq/web"
  authenticate :user do
    mount Sidekiq::Web => "/sidekiq"
  end
end
