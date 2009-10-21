# @see http://code.google.com/p/phusion-passenger/issues/detail?id=333

begin
  gem 'passenger'

  PhusionPassenger::Rack::RequestHandler.class_eval do
  
    CONTENT_TYPE        = "CONTENT_TYPE"       # :nodoc:
    HTTP_CONTENT_TYPE   = "HTTP_CONTENT_TYPE"  # :nodoc:
  
    protected
  
    def process_request_with_handling_content_type(env, input, output)
      if env[HTTP_CONTENT_TYPE] && env[CONTENT_TYPE]
        env.delete(HTTP_CONTENT_TYPE)
      elsif env[HTTP_CONTENT_TYPE] && !env[CONTENT_TYPE]
        env[CONTENT_TYPE] = env[HTTP_CONTENT_TYPE]
        env.delete(HTTP_CONTENT_TYPE)
      end
    
      process_request_without_handling_content_type(env, input, output)
    end
  
    alias_method_chain :process_request, :handling_content_type
  
  end
rescue NameError => e
  "Phusion Passenger not loaded. No fix needed. Handled error: #{e}"
end