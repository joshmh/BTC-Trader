module BtcTrader
  class Trader
    attr_reader :cash_balance, :btc_balance, :price, :trade_count

    TRADE_FEE = 0.0065
    TRADE_FEE_MULTIPLIER = 1 - TRADE_FEE
    
    def initialize(initial_balance)
      @cash_balance = initial_balance.to_f
      @btc_balance = 0.0
      @initial_balance = @cash_balance
      @total_fees = 0.0
      @trade_count = 0
      initialize_strategy
    end
    
    def initialize_strategy; end  # NO-OP
    
    def execute!(rec)
      @previous_price = @price
      @previous_time  = @time
      
      @price = rec.price
      @time  = rec.time
      
      execute_strategy!
    end
    
    def buy(amount)
      raise "Buy order exceeds balance" if amount > @cash_balance
      @cash_balance -= amount
      btc = amount / @price
      @btc_balance  += btc * TRADE_FEE_MULTIPLIER
      @total_fees += btc * TRADE_FEE * @price
      @trade_count += 1
    end
    
    def sell(amount)
      raise "Sell order exceeds balance" if amount > @btc_balance
      @btc_balance  -= amount
      cash =  amount * @price
      @cash_balance += cash * TRADE_FEE_MULTIPLIER
      @total_fees += cash * TRADE_FEE
      @trade_count += 1
    end
    
    def equity
      @cash_balance + @btc_balance * @price
    end
    
    def ror
      (equity - @initial_balance).to_f / @initial_balance
    end
    
    def ror_no_fee
      (equity + @total_fees - @initial_balance).to_f / @initial_balance
    end
  end
  
  # A trivial example that buys at the outset and holds until the end
  module Strategies
    class BuyAndHoldTrader < Trader
      def execute_strategy!
        buy cash_balance if @cash_balance > 0
      end
    end    
  end
end
