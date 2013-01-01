Blog::Application.routes.draw do
  devise_for :editors
  resources :posts
  get 'tags/:tag', to: 'posts#index', as: :tag
  root :to => 'posts#index'
end
