Brainpad::Application.routes.draw do
  resources :milestones
  resources :workouts
  resources :reminders
  resources :journals
  resources :contacts
  resources :connections
  resources :payments
  resources :accounts
  resources :people
  resources :links do
    collection do
      get 'find'
      get 'clean'
      get 'refresh_tags'
    end
  end
  
  match 'login/logout' => 'login#logout'

  root :to => "links#index"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
  
end
