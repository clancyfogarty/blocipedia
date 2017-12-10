Rails.application.routes.draw do
  resources :wikis
  devise_for :users

  get 'welcome/index'

  root 'welcome#index'

end
