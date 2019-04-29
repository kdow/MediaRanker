Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "homepages#index"

  resources :works
  resources :users, only: [:index, :show]

  get "/works/:id/upvote", to: "works#upvote", as: "upvote"

  get "/login", to: "users#login_form", as: "login"
  post "/login", to: "users#login"
  post "/logout", to: "users#logout", as: "logout"
end
