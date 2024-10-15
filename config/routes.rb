Rails.application.routes.draw do
  root to: 'sales#index'  # Isso define a página inicial como a action 'index' no controlador Sales
  
  resources :sales do
    collection do
      delete :destroy_all
      get :export
    end
  end
  
  # Outras rotas podem ir aqui
end
