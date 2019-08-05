Rails.application.routes.draw do
  resource :deposits, only: :create
  resource :transfers, only: :create
end
