ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'high_voltage/pages',
           :action => 'show',
           :id => 'welcome',
           :conditions => { :method => :get }

  map.resources :users,
                :only => [:edit, :update],
                :member => { :busy => :get } do |user|
    user.resources :calendars, :only => [:index, :new, :create]
  end
  
  map.sign_out  '/sessions/sign_out', :controller => 'sessions', :action => 'destroy', :conditions => { :method => :get }
  map.resources :sessions, :only => [:create, :destroy]

end
