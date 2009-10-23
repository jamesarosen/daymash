RiCal::PropertyValue::Period.class_eval do
  
  def for_parent(parent) #:nodoc:
    if timezone_finder.nil?
      @timezone_finder = parent
      self
    elsif timezone_finder == parent
      self
    else
      Period.new(parent, :value => value)
    end
  end
  
end
