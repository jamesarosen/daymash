module PerformanceMacros
  
  def should_take_on_average_less_than(limit, num_trials = 60, &block)
    should "take, on average, less than #{limit}" do
      result = nil
      num_trials.times do
        result = if result.nil?
          ::Benchmark.measure(&block.bind(self))
        else
          result + ::Benchmark.measure(&block.bind(self))
        end
      end
      result = result / num_trials
      assert result.real < limit, "average time should have been less than #{limit}, but was #{result.real}"
    end
  end
  
end
