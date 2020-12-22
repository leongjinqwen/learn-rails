Rails.application.routes.draw do
  # to declare route with view function 
  root "articles#index"

  resources :articles # The resources method also sets up URL and path helper methods
  # get "/articles", to: "articles#index"
  # get "/articles/:id", to: "articles#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
