Rails.application.routes.draw do
  root :to => 'movies#index'

  get 'movies/index'

  resources :movies
  # The priority is based upon order of creation: first created -> highest priority.
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
