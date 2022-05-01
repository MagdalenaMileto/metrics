Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #
  scope "/api", defaults: { format: :json } do
    post '/metrics', to: 'metrics#register'

    get '/metrics/average', to: 'metrics#average'

    resources :metrics, only: [:index] do

    end
  end
end
