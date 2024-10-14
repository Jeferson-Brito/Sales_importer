# config/routes.rb

Rails.application.routes.draw do
  resources :sales do
    collection do
      delete :destroy_all
      get :export
    end
  end
  
  # Outras rotas podem ir aqui
end
