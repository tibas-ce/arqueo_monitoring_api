Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :monitoring_sheets, only: [ :create, :index, :show, :update, :destroy ]
    end
  end
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
