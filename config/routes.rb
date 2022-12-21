# frozen_string_literal: true

Rails.application.routes.draw do
  root 'projects#index'

  devise_for :users

  resources :developers

  resources :projects do
    member do
      get :manage_developers
      get :add_developer
    end

    resources :sprints, only: %i[index create]
  end
end
