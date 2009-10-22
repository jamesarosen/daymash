ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'high_voltage/pages',
           :action => 'show',
           :id => 'welcome',
           :conditions => { :method => :get }

  map.resources :users,
                :only => [:new, :create, :edit, :update]
                
  map.sign_out  '/sessions/sign_out', :controller => 'user_sessions', :action => 'destroy', :conditions => { :method => :get }
  map.resources :user_sessions,
                :only => [:new, :create, :destroy]

end
