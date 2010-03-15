module CucumberRailsDebug
  
  def where
    puts "#{@request.env["SERVER_NAME"]}#{@request.env["REQUEST_URI"]}"
  end
 
  def how
    puts "Request: #{@request.parameters.inspect}"
    puts "Session: #{@request.session.inspect}"
  end
 
  def html
    body = @response.body
    body = body.join("\n") if body.kind_of?(Array)
    puts body.gsub("\n", "\n ")
  end
 
  def display(decoration="\n#{'*' * 80}\n\n")
    puts decoration
    yield
    puts decoration
  end
end
 
World(CucumberRailsDebug)
 
Then "debug" do
  debugger
  stop_here = 1
end
 
Then "what" do
  display do
    where if @request
    how if @request
    html if @response
  end
end
 
Then "pending" do
  pending @__executor.instance_variable_get("@feature_file")
end