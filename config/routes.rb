# frozen_string_literal: true

Rails.application.routes.draw do
  resource :deposits, only: :create
  resource :transfers, only: :create

  resources :accounts, only: :create do
    resource :balance, module: 'accounts', only: :show
  end
end
