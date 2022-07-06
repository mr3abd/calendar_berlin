Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "event#index"
  post 'seed_data', to: 'event#seed_data'
end
