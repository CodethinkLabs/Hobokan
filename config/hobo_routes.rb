# This is an auto-generated file: don't edit!
# You can add your own routes in the config/routes.rb file
# which will override the routes in this file.

Hobokan::Application.routes.draw do


  # Resource routes for controller "buckets"
  get 'buckets/new(.:format)', :as => 'new_bucket'
  get 'buckets/:id/edit(.:format)' => 'buckets#edit', :as => 'edit_bucket'
  get 'buckets/:id(.:format)' => 'buckets#show', :as => 'bucket', :constraints => { :id => %r([^/.?]+) }
  post 'buckets(.:format)' => 'buckets#create', :as => 'create_bucket'
  put 'buckets/:id(.:format)' => 'buckets#update', :as => 'update_bucket', :constraints => { :id => %r([^/.?]+) }
  delete 'buckets/:id(.:format)' => 'buckets#destroy', :as => 'destroy_bucket', :constraints => { :id => %r([^/.?]+) }

  # Owner routes for controller "buckets"
  get 'projects/:project_id/buckets/new(.:format)' => 'buckets#new_for_project', :as => 'new_bucket_for_project'
  post 'projects/:project_id/buckets(.:format)' => 'buckets#create_for_project', :as => 'create_bucket_for_project'


  # Owner routes for controller "comments"
  post 'items/:item_id/comments(.:format)' => 'comments#create_for_item', :as => 'create_comment_for_item'


  # Lifecycle routes for controller "items"
  put 'items/:id/archive(.:format)' => 'items#do_archive', :as => 'do_item_archive'
  get 'items/:id/archive(.:format)' => 'items#archive', :as => 'item_archive'
  put 'items/:id/restore(.:format)' => 'items#do_restore', :as => 'do_item_restore'
  get 'items/:id/restore(.:format)' => 'items#restore', :as => 'item_restore'

  # Resource routes for controller "items"
  get 'items/new(.:format)', :as => 'new_item'
  get 'items/:id/edit(.:format)' => 'items#edit', :as => 'edit_item'
  get 'items/:id(.:format)' => 'items#show', :as => 'item', :constraints => { :id => %r([^/.?]+) }
  post 'items(.:format)' => 'items#create', :as => 'create_item'
  put 'items/:id(.:format)' => 'items#update', :as => 'update_item', :constraints => { :id => %r([^/.?]+) }
  delete 'items/:id(.:format)' => 'items#destroy', :as => 'destroy_item', :constraints => { :id => %r([^/.?]+) }

  # Owner routes for controller "items"
  get 'projects/:project_id/items/new(.:format)' => 'items#new_for_project', :as => 'new_item_for_project'
  post 'projects/:project_id/items(.:format)' => 'items#create_for_project', :as => 'create_item_for_project'

  # Show action routes for controller "items"
  get 'items/:id/ajax_item(.:format)' => 'items#ajax_item', :as => 'item_ajax_item'


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

  # Show action routes for controller "lanes"
  get 'lanes/:id/show(.:format)' => 'lanes#show', :as => 'lane_show'
  get 'lanes/:id/clear(.:format)' => 'lanes#clear', :as => 'lane_clear'

  # Reorder routes for controller "lanes"
  post 'lanes/reorder(.:format)', :as => 'reorder_lanes'


  # Resource routes for controller "milestones"
  get 'milestones/new(.:format)', :as => 'new_milestone'
  get 'milestones/:id/edit(.:format)' => 'milestones#edit', :as => 'edit_milestone'
  get 'milestones/:id(.:format)' => 'milestones#show', :as => 'milestone', :constraints => { :id => %r([^/.?]+) }
  post 'milestones(.:format)' => 'milestones#create', :as => 'create_milestone'
  put 'milestones/:id(.:format)' => 'milestones#update', :as => 'update_milestone', :constraints => { :id => %r([^/.?]+) }
  delete 'milestones/:id(.:format)' => 'milestones#destroy', :as => 'destroy_milestone', :constraints => { :id => %r([^/.?]+) }

  # Owner routes for controller "milestones"
  get 'projects/:project_id/milestones/new(.:format)' => 'milestones#new_for_project', :as => 'new_milestone_for_project'
  post 'projects/:project_id/milestones(.:format)' => 'milestones#create_for_project', :as => 'create_milestone_for_project'


  # Lifecycle routes for controller "projects"
  put 'projects/:id/archive(.:format)' => 'projects#do_archive', :as => 'do_project_archive'
  get 'projects/:id/archive(.:format)' => 'projects#archive', :as => 'project_archive'
  put 'projects/:id/reopen(.:format)' => 'projects#do_reopen', :as => 'do_project_reopen'
  get 'projects/:id/reopen(.:format)' => 'projects#reopen', :as => 'project_reopen'

  # Resource routes for controller "projects"
  get 'projects(.:format)' => 'projects#index', :as => 'projects'
  get 'projects/new(.:format)', :as => 'new_project'
  get 'projects/:id/edit(.:format)' => 'projects#edit', :as => 'edit_project'
  get 'projects/:id(.:format)' => 'projects#show', :as => 'project', :constraints => { :id => %r([^/.?]+) }
  post 'projects(.:format)' => 'projects#create', :as => 'create_project'
  put 'projects/:id(.:format)' => 'projects#update', :as => 'update_project', :constraints => { :id => %r([^/.?]+) }
  delete 'projects/:id(.:format)' => 'projects#destroy', :as => 'destroy_project', :constraints => { :id => %r([^/.?]+) }

  # Show action routes for controller "projects"
  get 'projects/:id/kanban(.:format)' => 'projects#kanban', :as => 'project_kanban'
  get 'projects/:id/triage(.:format)' => 'projects#triage', :as => 'project_triage'
  get 'projects/:id/done(.:format)' => 'projects#done', :as => 'project_done'
  get 'projects/:id/stats(.:format)' => 'projects#stats', :as => 'project_stats'
  get 'projects/:id/change_log(.:format)' => 'projects#change_log', :as => 'project_change_log'


  # Index action routes for controller "users"
  get 'users/workload(.:format)', :as => 'workload_users'
  get 'users/admin(.:format)', :as => 'admin_users'

  # Lifecycle routes for controller "users"
  put 'users/:id/accept_invitation(.:format)' => 'users#do_accept_invitation', :as => 'do_user_accept_invitation'
  get 'users/:id/accept_invitation(.:format)' => 'users#accept_invitation', :as => 'user_accept_invitation'
  put 'users/:id/reset_password(.:format)' => 'users#do_reset_password', :as => 'do_user_reset_password'
  get 'users/:id/reset_password(.:format)' => 'users#reset_password', :as => 'user_reset_password'
  put 'users/:id/deactivate(.:format)' => 'users#do_deactivate', :as => 'do_user_deactivate'
  get 'users/:id/deactivate(.:format)' => 'users#deactivate', :as => 'user_deactivate'

  # Resource routes for controller "users"
  get 'users/:id/edit(.:format)' => 'users#edit', :as => 'edit_user'
  get 'users/:id(.:format)' => 'users#show', :as => 'user', :constraints => { :id => %r([^/.?]+) }
  post 'users(.:format)' => 'users#create', :as => 'create_user'
  put 'users/:id(.:format)' => 'users#update', :as => 'update_user', :constraints => { :id => %r([^/.?]+) }
  delete 'users/:id(.:format)' => 'users#destroy', :as => 'destroy_user', :constraints => { :id => %r([^/.?]+) }

  # Show action routes for controller "users"
  get 'users/:id/account(.:format)' => 'users#account', :as => 'user_account'
  get 'users/:id/done(.:format)' => 'users#done', :as => 'user_done'

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
