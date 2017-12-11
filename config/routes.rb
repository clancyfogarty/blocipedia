Rails.application.routes.draw do
  resources :wikis
  resources :charges, only: [:new, :create]
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    post 'users/registrations/downgrade' => 'users/registrations#downgrade'
  end

  get 'welcome/index'

  root 'welcome#index'

end
