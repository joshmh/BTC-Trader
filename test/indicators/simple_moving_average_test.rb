$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'rubygems'
require 'minitest/autorun'
require 'btc_trader/indicators_manager'

class SimpleMovingAverageTest < MiniTest::Unit::TestCase
  def setup
    @sma = BtcTrader::Indicators::SimpleMovingAverage.new 5
  end
  
  def test_basic    
    data = [ 1, 5, 12, 3, 12, 9, 10, 32, 0, 3, 5 ]
    data.each {|v| @sma.update! v }
    assert_equal 10, @sma.value

    assert_equal 8.8, @sma.update!(4)
    assert_equal 8.8, @sma.value
  end
  
  def test_partial
    data = [ 1, 5, 12, 3 ]
    data.each {|v| @sma.update! v }
    assert_nil @sma.value
  end
  
  def test_empty
    assert_nil @sma.value
  end
end