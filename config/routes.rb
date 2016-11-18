Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # IIIF Image API Endpoint
  mount Riiif::Engine => '/image-service', as: 'riiif'
end
