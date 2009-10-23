module RiCal
  module CoreExtensions
    
    module Range
      
      module Conversions
        
        def to_ri_cal_period_value(timezone_finder = nil)
          value = [self.begin, self.end].map do |time|
            time.to_ri_cal_date_time_value.value
          end.join('/')
          RiCal::PropertyValue::Period.new(timezone_finder, :value => value)
        end
        
      end
      
    end
    
  end
end
