Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'metrics#index'

  match 'performances/all/edit' => 'performances#edit_all', :as => :edit_all, :via => :get
  match 'performances/all' => 'performances#update_all', :as => :update_all, :via => :put

  resources :users do
    resources :metrics do
      resources :performances
    end
  end

end
