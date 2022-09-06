Rails.application.routes.draw do
  devise_for :users

  resources :journeys

  root "journeys#index"
end
