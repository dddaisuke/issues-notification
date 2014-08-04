Rails.application.routes.draw do
  resource :top, only: :show
  resource :github do
    post :webhook, on: :collection
  end
  resource :cache_clear, only: :show
  get '/auth/:provider/callback' => 'sessions#create'
  root 'top#show'
end
