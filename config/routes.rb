Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "tasks#index"

  resources :sessions do
     get 'logout', on: :collection
  end
  resources :registrations, only: %i[new create]
  resources :tasks do
    get 'start_scraping', on: :member
  end
end
