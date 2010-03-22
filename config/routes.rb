ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'high_voltage/pages',
           :action => 'show',
           :id => 'welcome',
           :conditions => { :method => :get }

  map.resources :users,
                :only => [:create, :show, :edit, :update] do |user|
    user.resources :calendars, :only => [:index, :new, :create, :destroy],
                               :member => { :undestroy => :put }
    user.resources :credentials, :only => [:create, :destroy],
                                 :member => { :undestroy => :put }
    user.resource  :aggregate, :only => [:show]
  end
  
  map.sign_out  '/sessions/sign_out', :controller => 'sessions', :action => 'destroy', :conditions => { :method => :get }
  map.resources :sessions, :only => [:create, :destroy]

end
