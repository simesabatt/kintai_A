Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'users/employees_on_duty', to: 'users#employees_on_duty'
  
  get 'bases/new'
  resources :bases
  get 'users/basic_info'

  resources :users do
    collection { post :import }
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'users/check'
      patch 'update_month_request'
      get 'kintai_log'
      patch 'update_kintai_log'
    end
    resources :attendances, only: :update do
      member do
        get 'edit_overwork_request'
        patch 'update_overwork_request'
        get 'edit_overwork_request_confirm'
        patch 'update_overwork_request_confirm'
        get 'edit_kintai_change_confirm'
        patch 'update_kintai_change_confirm'
        get 'edit_month_change_confirm'
        patch 'update_month_change_confirm'
      end
    end
    # resources :bases do
    # end
  end
end