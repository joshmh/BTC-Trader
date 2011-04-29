require 'csv'
require 'metrics_manager'
require 'indicators_manager'
require 'trader'

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
    def initialize
      @data = []
    end
    
    def push(record)
      @data << record
    end
    
    def each
      @data.each {|rec| yield rec }
    end
  end

  class Engine
    def initialize(data)
      @data = HistoricalData.new
      @metrics = MetricsManager.new
      @indicators = IndicatorsManager.new
      @trader = Trader.new @indicators
      parse_historical_data(data)
    end
    
    def run
      @data.each do |rec|
        @metrics.update! rec
        @indicators.update! rec
        @trader.execute! rec
      end
    end
    
    private
    
    def parse_historical_data(data)
      CSV.foreach(data) do |row|
        @data.push HistoricalRecord.new( :price => row[1], :volume => row[2], :time => DateTime.strptime(row[0], '%s') )
      end
    end

  end
end

e = BtcTrader::Engine.new 'data/historical.csv'
e.run
