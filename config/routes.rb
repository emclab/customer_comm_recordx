CustomerCommRecordx::Engine.routes.draw do
  
  resources :customer_comm_records, :only => [:index, :new, :create]
  resources :customer_comm_records do
    collection do
      get :search
      put :search_results      
      get :stats
      put :stats_results
    end      
  end

  root :to => 'customer_comm_records#index'
end
