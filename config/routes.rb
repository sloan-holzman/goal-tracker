Rails.application.routes.draw do
  # learned how to update users from: https://jacopretorius.net/2014/03/adding-custom-fields-to-your-devise-user-model-in-rails-4.html
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'metrics#index'

  # match 'performances/all/edit' => 'performances#edit_all', :as => :edit_all, :via => :get
  # match 'performances/all' => 'performances#update_all', :as => :update_all, :via => :put

  get 'demos' => 'demos#index', :as => :demo
  get 'profiles/show' => 'profiles#show', :as => :profile
  get 'performances/all/edit' => 'performances#edit_all', :as => :edit_all
  put 'performances/all' => 'performances#update_all', :as => :update_all
  get 'performances/day/select' => 'performances#select_day', :as => :select_day
  get 'performances/:date/edit' => 'performances#edit_day', :as => :edit_day
  put 'performances/:date' => 'performances#update_day', :as => :update_day
  get 'request/all' => 'requests#all'
  get 'groups/all' => 'groups#all'
  post 'users/:user_id/groups/:group_id/requests/:id/approve' => 'requests#approve'
  delete 'users/:user_id/groups/:group_id/requests/:id/reject' => 'requests#reject'
  post 'users/:user_id/groups/:group_id/invitations/:id/accept' => 'invitations#accept'
  delete 'users/:user_id/groups/:group_id/invitations/:id/reject' => 'invitations#reject'
  delete 'users/:user_id/groups/:group_id/memberships/destroy' => 'memberships#destroy', :as => :leave_group


  resources :users do
    resources :groups do
      resources :requests
      resources :invitations
      resources :competitions
    end
    resources :metrics do
      resources :performances
    end
  end

end
