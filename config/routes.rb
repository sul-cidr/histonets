Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # IIIF Image API Endpoint
  mount Riiif::Engine => '/image-service', as: 'riiif'

  # Resourceful routes for CollectionTemplates
  resources :collection_templates, only: [:new, :create, :show, :index, :destroy] do
    resources :build,
              only: [:show, :update], controller: 'collection_templates/build'
    resources :image_templates, only: [:edit, :update, :destroy]
  end
end
