Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'metrics#index'

  # match 'performances/all/edit' => 'performances#edit_all', :as => :edit_all, :via => :get
  # match 'performances/all' => 'performances#update_all', :as => :update_all, :via => :put

  get 'performances/all/edit' => 'performances#edit_all', :as => :edit_all
  put 'performances/all' => 'performances#update_all', :as => :update_all
  get 'metrics/past' => 'metrics#past', :as => :past
  get 'performances/day/select' => 'performances#select_day', :as => :select_day
  get 'performances/:date/edit' => 'performances#edit_day', :as => :edit_day
  put 'performances/:date' => 'performances#update_day', :as => :update_day


  resources :users do
    resources :groups
    resources :metrics do
      resources :performances
    end
  end

end
