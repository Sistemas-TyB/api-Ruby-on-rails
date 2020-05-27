Rails.application.routes.draw do  
  #resources :tokens
  #devise_for :users
  scope "(:locale)", locale: /es|en/ do
    namespace :api, :default => {format: "json"} do
      namespace :v1 do 
      resources :users do
        collection do 
          post 'login'
      end
      root 'home#index'
      get 'home/index'
      end
    end
  end
 end
end
  