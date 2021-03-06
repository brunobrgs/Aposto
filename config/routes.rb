Rails3BootstrapDeviseCancan::Application.routes.draw do

  localized do
    resources :challenges
  end

  match '/extrato', :to => 'home#transactions'
  match '/vote', :to => 'challenges#vote'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:show, :index]
end
