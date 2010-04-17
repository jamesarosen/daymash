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
    user.resource  :aggregate, :only => [:show],
                               :member => { :reset_privacy_token => :put }
  end
  
  map.sign_out  '/sessions/sign_out', :controller => 'sessions', :action => 'destroy', :conditions => { :method => :get }
  map.resources :sessions, :only => [:create, :destroy]
  
  # auto-added by HighVoltage, but want it above the *path glob route below:
  map.resources :pages,  :controller => 'high_voltage/pages', :only   => [:show]
  
  # catch-all
  map.not_found '*path', :controller => 'high_voltage/pages', :action => 'show', :id => 'not_found'

end
