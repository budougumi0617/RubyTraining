Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # 参考ページ
  # https://techracho.bpsinc.jp/baba/2014_03_03/15619
  config = Rails.application.config.baukis

  constraints host: config[:staff][:host] do
    namespace :staff, path: config[:staff][:path] do
      root 'top#index'
      get 'login' => 'sessions#new', as: :login
      resource :session, only: [:create, :destroy]
      resource :account, except: [:new, :create] do
        patch :confirm
      end
      resource :password, only: [:show, :edit, :update]
      resources :customers # 複数リソース。:id付きのURLが生成される。
      resources :programs do
        patch :entries, on: :member # 集合的に扱う場合は on: :collection
      end
      # メッセージの件数を集計する。
      # アクションは問い合わせ一覧、送信一覧、ゴミ箱、を表示する。
      resources :messages, only: [ :index, :show, :destroy ] do
        get :inbound, :outbound, :deleted, :count, on: :collection
        # 返信用のルーティング
        resource :reply, only: [ :new, :create ] do
          post :confirm
        end
      end
    end
  end

  constraints host: config[:admin][:host] do
    namespace :admin, path: config[:admin][:path] do
      root 'top#index'
      get 'login' => 'sessions#new', as: :login
      resource :session, only: [:create, :destroy]
      # 各スタッフごとのイベント管理ページ
      # resourceとresourcesの使い分けに気をつける。
      # https://techracho.bpsinc.jp/baba/2014_03_03/15619
      resources :staff_members do
        resources :staff_events, only: [:index]
      end
      # 全スタッフのイベント管理ページ
      resources :staff_events, only: [:index]
      # 許可IPアドレスの管理。一括削除を行うので、deleteアクションはコレクションルーティングとして設定している。
      resources :allowed_sources, only: [ :index, :create ] do
        delete :delete, on: :collection # idを指定しない感じ。
      end
    end
  end

  constraints host: config[:customer][:host] do
    namespace :customer, path: config[:customer][:path] do
      root 'top#index'
      get 'login' => 'sessions#new', as: :login
      resource :session, only: [ :create, :destroy ]
      resource :account, except: [ :new, :create, :destroy ] do
        patch :confirm # 入れ子のルーティング。
      end
      resources :programs, only: [ :index, :show ] do
        resources :entries, only: [ :create ] do
          patch :cancel, on: :member
        end
      end
      resources :messages, only: [ :new, :create ] do
        post :confirm, on: :collection
      end
    end
  end

  root 'errors#routing_error'
  get '*anything' => 'errors#routing_error'

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
