require 'csv'
require 'btc_trader/metrics_manager'
require 'btc_trader/indicators_manager'
require 'btc_trader/trader'
require 'btc_trader/strategies/simple_sma_trader'

module BtcTrader
  class HistoricalRecord
    attr_reader :price, :volume, :time
    
    def initialize(hash)
      @price = hash[:price]
      @volume = hash[:volume]
      @time = hash[:time]
    end
  end
  
  class HistoricalData
    def initialize(file)
      @file = file
    end
        
    def each
      cutoff = DateTime.parse('2010-11-1')
      CSV.foreach(@file) do |row|
        rec = HistoricalRecord.new( :price => row[1].to_f, 
          :volume => row[2].to_f, :time => DateTime.strptime(row[0], '%s') )
        next if rec.time < cutoff
        yield rec
      end
    end
  end

  class Engine
    attr_reader :trader
    
    def initialize(data)
      @data = HistoricalData.new data
      @trader = Strategies::SimpleSmaTrader.new 10_000
#      @trader = Strategies::BuyAndHoldTrader.new 10_000
    end
    
    def run
      @data.each do |rec|
        @trader.execute! rec
      end
    end
    
  end
end
