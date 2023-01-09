Rails.application.routes.draw do
  devise_for :users

  resources :journey_acquisitions, only: [:create]
  resources :journeys,             only: [:index, :new, :update, :show, :create, :destroy] do
    resources :journey_stops, only: [:new, :create, :destroy]
  end
  resources :pelicans,             only: [:show], param: :username
  resources :watch_journeys,       only: [:show], param: :access_code

  root "journeys#index"
end
