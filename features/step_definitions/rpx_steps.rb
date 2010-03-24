CredentialsController.class_eval do
  append_before_filter do |controller|
    if controller.params[:user_id].to_s == 'current'
      controller.params[:user_id] = controller.current_user.to_param
    end
  end
end

Given /^RPX will return me to the (.+) page and supplies the following:$/ do |page, table|
  FakeWeb.allow_net_connect = false
  
  unless ActionController::Routing::Routes.named_routes[:rpx_sign_in]
    ActionController::Routing::Routes.draw do |map|
      map.rpx_sign_in   '/openid/v2/signin',  :controller => 'Credentials',
                                              :action => 'create', 
                                              :token => 'something',
                                              :user_id => 'current'
    end
  end
  
  FakeWeb.register_uri :post, %r|^https?://rpxnow.com(?:\:443)?/api/v2/auth_info|,
                              :body => { :profile => table.hashes.first }.to_json
end
