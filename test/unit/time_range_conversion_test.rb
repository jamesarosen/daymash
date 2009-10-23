require 'test_helper'
require 'ri_cal/core_extensions/range'

class TimeRangeConversionTest < ActiveSupport::TestCase
  
  context 'a Range of two Times in UTC' do
    
    setup do
      @start = (Time.now).utc
      @end   = (@start + 1.hour).utc
      @range = (@start..@end)
      @period = @range.to_ri_cal_period_value(RiCal.Calendar)
    end
    
    should 'convert to a RiCal Period' do
      assert @period.kind_of?(RiCal::PropertyValue::Period)
    end
    
    should 'retain the proper time information' do
      assert_equal @start.to_ri_cal_date_time_value, @period.dtstart
      assert_equal @end.to_ri_cal_date_time_value,   @period.dtend
    end
    
  end
  
  context 'a Range of two RiCal::PropertyValue::DateTimes in UTC' do
    
    setup do
      @start = RiCal::PropertyValue::DateTime.new(nil, :value => "19970101T180000Z")
      @end   = RiCal::PropertyValue::DateTime.new(nil, :value => "19970102T070000Z")
      @range = (@start..@end)
      @period = @range.to_ri_cal_period_value(nil)
    end
    
    should 'convert to a RiCal Period' do
      assert @period.kind_of?(RiCal::PropertyValue::Period)
    end
    
    should 'retain the proper time information' do
      assert_equal @start, @period.dtstart
      assert_equal @end,   @period.dtend
    end
  end
  
end
