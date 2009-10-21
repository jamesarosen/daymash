class User < ActiveRecord::Base
  acts_as_authentic
  
  def to_s
    display_name.present? ? display_name : username
  end
end
