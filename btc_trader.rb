$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'btc_trader/engine'

e = BtcTrader::Engine.new 'data/historical.csv'
e.run
puts "ROR: #{'%.2f%' % (e.trader.ror * 100)}, ROR (less fees): #{'%.2f%' % (e.trader.ror_no_fee * 100)}, Trade Count: #{e.trader.trade_count}"
