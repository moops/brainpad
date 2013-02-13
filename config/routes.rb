Brainpad::Application.routes.draw do

  root :to => "welcome#index"
  get 'signup', to: 'people#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  
  resources :users
  resources :sessions

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

end
