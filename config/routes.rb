Rails.application.routes.draw do
  devise_for :users

  resources :journey_acquisitions, only: [] do
    collection do
      get :checkout_session_redirect
    end
  end
  resources :journeys,             only: [:index, :new, :update, :show, :create, :destroy] do
    resources :journey_stops, only: [:new, :create, :destroy]
  end
  resources :pelicans,             only: [:show], param: :username
  resources :relationships,        only: [:create, :destroy]
  resources :payments,             only: [] do
    collection do
      post :create_checkout_session
    end
  end
  resources :watch_journeys,       only: [:show], param: :access_code

  root "journeys#index"
end
