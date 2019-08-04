Rails.application.routes.draw do
  resource :deposits, only: :create
end
