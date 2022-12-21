Rails.application.routes.draw do
  root "projects#index"

  devise_for :users

  resources :users, only: %i[new create destroy update]

  resources :projects
end
