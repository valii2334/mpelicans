Rails.application.routes.draw do
  devise_for :users

  resources :journeys, only: [:index, :new, :show, :create] do
    resources :journey_stops, only: [:new, :create]
  end

  get '/watch_journeys/:access_code', to: 'watch_journeys#show', as: :watch_journeys

  root "journeys#index"
end
