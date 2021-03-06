Rails.application.routes.draw do
  namespace :admin do
  get 'scenarios/index'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#home'

  get 'unauthorized', to: "pages#unauthorized"

  devise_for :user, controllers: { registrations: 'registrations' }

  #devise_for :user

  # scope '/admin' do
  #   resources :users do
  #     collection do
  #       get 'invite'
  #       post "invite", to: "users#send_invites"
  #     end
  #   end
  # end

  namespace :admin do
    resources :users do
      collection do
        get 'invite'
        post "invite", to: "users#send_invites"
      end
    end

    resources :scenarios do
      collection do
        post 'ajax_save'
        get 'ajax_load'
      end
    end
  end

  resources :scenarios do
    collection do
      get 'update_progress'
    end
  end

  resources :scenario_sessions

  resources :messages do
    collection do
      get 'inbox'
      get 'outbox'
      get '/:id/reply' => 'messages#reply_new', as: :reply
      post '/:id/reply' => 'messages#reply_create'
    end
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
