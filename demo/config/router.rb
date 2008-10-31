Merb.logger.info("Compiling routes...")
Merb::Router.prepare do

  identify Sequel::Model => :pk do
    resources :wikis do
      resources :pages do
        resources :comments
      end
    end
  end
      
  match('/').to(:controller => 'wikis', :action =>'index')
end