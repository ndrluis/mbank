Rails.application.routes.draw do
  resource :deposits, only: :create
  resource :transfers, only: :create

  resources :accounts, except: %w(new create update destroy index show) do
    resource :balance, module: "accounts", only: :show
  end
end
