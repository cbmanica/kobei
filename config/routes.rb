Kobei::Application.routes.draw do
  resources :earthquakes, :only => [:index], :defaults => { :format => 'json' }
  resources :home, :only => [:index]
  root :to => 'home#index'
end
