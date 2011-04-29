module BtcTrader
  module Indicators
    class SimpleMovingAverage
      attr_reader :value
      
      def initialize(n)
        @n = n
        @data = []
        @value = nil
      end
      
      def update!(current)
        last = @data.size == @n ? @data.pop : nil
        @data.unshift current
        @value = last ? ( @data.inject(0) {|sum, x| sum + x }.to_f / @n ) : nil
      end
    end
  end

  class IndicatorsManager
    
  end
end