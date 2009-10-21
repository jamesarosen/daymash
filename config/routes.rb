ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'high_voltage/pages',
           :action => 'show',
           :id => 'welcome',
           :conditions => { :method => :get }

  map.resources :users,
                :only => [:new, :create]

end
