# This is an auto-generated file: don't edit!
# You can add your own routes in the config/routes.rb file
# which will override the routes in this file.

CtKanban::Application.routes.draw do


  # Resource routes for controller "history_entries"
  get 'history_entries/new(.:format)', :as => 'new_history_entry'
  get 'history_entries/:id/edit(.:format)' => 'history_entries#edit', :as => 'edit_history_entry'
  get 'history_entries/:id(.:format)' => 'history_entries#show', :as => 'history_entry', :constraints => { :id => %r([^/.?]+) }
  post 'history_entries(.:format)' => 'history_entries#create', :as => 'create_history_entry'
  put 'history_entries/:id(.:format)' => 'history_entries#update', :as => 'update_history_entry', :constraints => { :id => %r([^/.?]+) }
  delete 'history_entries/:id(.:format)' => 'history_entries#destroy', :as => 'destroy_history_entry', :constraints => { :id => %r([^/.?]+) }


  # Resource routes for controller "items"
  get 'items/new(.:format)', :as => 'new_item'
  get 'items/:id/edit(.:format)' => 'items#edit', :as => 'edit_item'
  get 'items/:id(.:format)' => 'items#show', :as => 'item', :constraints => { :id => %r([^/.?]+) }
  post 'items(.:format)' => 'items#create', :as => 'create_item'
  put 'items/:id(.:format)' => 'items#update', :as => 'update_item', :constraints => { :id => %r([^/.?]+) }
  delete 'items/:id(.:format)' => 'items#destroy', :as => 'destroy_item', :constraints => { :id => %r([^/.?]+) }

  # Reorder routes for controller "items"
  post 'items/reorder(.:format)', :as => 'reorder_items'


  # Resource routes for controller "lanes"
  get 'lanes/new(.:format)', :as => 'new_lane'
  get 'lanes/:id/edit(.:format)' => 'lanes#edit', :as => 'edit_lane'
  get 'lanes/:id(.:format)' => 'lanes#show', :as => 'lane', :constraints => { :id => %r([^/.?]+) }
  post 'lanes(.:format)' => 'lanes#create', :as => 'create_lane'
  put 'lanes/:id(.:format)' => 'lanes#update', :as => 'update_lane', :constraints => { :id => %r([^/.?]+) }
  delete 'lanes/:id(.:format)' => 'lanes#destroy', :as => 'destroy_lane', :constraints => { :id => %r([^/.?]+) }

  # Owner routes for controller "lanes"
  get 'projects/:project_id/lanes/new(.:format)' => 'lanes#new_for_project', :as => 'new_lane_for_project'
  post 'projects/:project_id/lanes(.:format)' => 'lanes#create_for_project', :as => 'create_lane_for_project'

  # Reorder routes for controller "lanes"
  post 'lanes/reorder(.:format)', :as => 'reorder_lanes'


  # Resource routes for controller "projects"
  get 'projects(.:format)' => 'projects#index', :as => 'projects'
  get 'projects/new(.:format)', :as => 'new_project'
  get 'projects/:id/edit(.:format)' => 'projects#edit', :as => 'edit_project'
  get 'projects/:id(.:format)' => 'projects#show', :as => 'project', :constraints => { :id => %r([^/.?]+) }
  post 'projects(.:format)' => 'projects#create', :as => 'create_project'
  put 'projects/:id(.:format)' => 'projects#update', :as => 'update_project', :constraints => { :id => %r([^/.?]+) }
  delete 'projects/:id(.:format)' => 'projects#destroy', :as => 'destroy_project', :constraints => { :id => %r([^/.?]+) }


  # Resource routes for controller "statistics"
  get 'statistics(.:format)' => 'statistics#index', :as => 'statistics'
  get 'statistics/new(.:format)', :as => 'new_statistic'
  get 'statistics/:id/edit(.:format)' => 'statistics#edit', :as => 'edit_statistic'
  get 'statistics/:id(.:format)' => 'statistics#show', :as => 'statistic', :constraints => { :id => %r([^/.?]+) }
  post 'statistics(.:format)' => 'statistics#create', :as => 'create_statistic'
  put 'statistics/:id(.:format)' => 'statistics#update', :as => 'update_statistic', :constraints => { :id => %r([^/.?]+) }
  delete 'statistics/:id(.:format)' => 'statistics#destroy', :as => 'destroy_statistic', :constraints => { :id => %r([^/.?]+) }


  # Lifecycle routes for controller "users"
  put 'users/:id/accept_invitation(.:format)' => 'users#do_accept_invitation', :as => 'do_user_accept_invitation'
  get 'users/:id/accept_invitation(.:format)' => 'users#accept_invitation', :as => 'user_accept_invitation'
  put 'users/:id/reset_password(.:format)' => 'users#do_reset_password', :as => 'do_user_reset_password'
  get 'users/:id/reset_password(.:format)' => 'users#reset_password', :as => 'user_reset_password'

  # Resource routes for controller "users"
  get 'users(.:format)' => 'users#index', :as => 'users'
  get 'users/:id/edit(.:format)' => 'users#edit', :as => 'edit_user'
  get 'users/:id(.:format)' => 'users#show', :as => 'user', :constraints => { :id => %r([^/.?]+) }
  post 'users(.:format)' => 'users#create', :as => 'create_user'
  put 'users/:id(.:format)' => 'users#update', :as => 'update_user', :constraints => { :id => %r([^/.?]+) }
  delete 'users/:id(.:format)' => 'users#destroy', :as => 'destroy_user', :constraints => { :id => %r([^/.?]+) }

  # Show action routes for controller "users"
  get 'users/:id/account(.:format)' => 'users#account', :as => 'user_account'

  # User routes for controller "users"
  match 'login(.:format)' => 'users#login', :as => 'user_login'
  get 'logout(.:format)' => 'users#logout', :as => 'user_logout'
  match 'forgot_password(.:format)' => 'users#forgot_password', :as => 'user_forgot_password'

  namespace :admin do


    # Lifecycle routes for controller "admin/users"
    post 'users/invite(.:format)' => 'users#do_invite', :as => 'do_user_invite'
    get 'users/invite(.:format)' => 'users#invite', :as => 'user_invite'

    # Resource routes for controller "admin/users"
    get 'users(.:format)' => 'users#index', :as => 'users'
    get 'users/new(.:format)', :as => 'new_user'
    get 'users/:id/edit(.:format)' => 'users#edit', :as => 'edit_user'
    get 'users/:id(.:format)' => 'users#show', :as => 'user', :constraints => { :id => %r([^/.?]+) }
    post 'users(.:format)' => 'users#create', :as => 'create_user'
    put 'users/:id(.:format)' => 'users#update', :as => 'update_user', :constraints => { :id => %r([^/.?]+) }
    delete 'users/:id(.:format)' => 'users#destroy', :as => 'destroy_user', :constraints => { :id => %r([^/.?]+) }

  end

end
