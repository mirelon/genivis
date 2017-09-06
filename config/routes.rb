Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/family/show/:profile_id', to: 'family#show'
  get '/auth/callback', to: 'auth#callback'
  get '/auth/auth', to: 'auth#auth'
  root to: 'family#show'
end
