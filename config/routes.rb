# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  resources :journey_acquisitions, only: [] do
    collection do
      get :checkout_session_redirect
    end
  end
  resources :journeys, only: %i[index new show create destroy] do
    resources :journey_stops, only: %i[new show create destroy]
  end
  resources :pelicans,             only: %i[index show edit update], param: :username
  resources :relationships,        only: %i[create destroy]
  resources :payments,             only: [] do
    collection do
      post :create_checkout_session
    end
  end
  resources :watch_journeys, only: [:show], param: :access_code
  resources :map_pins,       only: [:index, :create, :destroy]

  resources :company, only: [] do
    collection do
      get :about_us
    end
  end

  root 'journeys#index'
end
