class TransactionController < ApplicationController

  def index
    if !session[:user]
      redirect_to "/login"
    else
      @ticker_follows = Ticker.all
      @user = User.find(session[:user_id])

      @portfolio_owned = Transaction.where(user_id: session[:user_id], transaction_type: 'buy').group(:user_id).sum(:trade_price)
      @portfolio_sold = Transaction.where(user_id: session[:user_id], transaction_type: 'sell').group(:user_id).sum(:trade_price)

      @shares_owned = Transaction.where(user_id: session[:user_id], transaction_type: 'buy').group(:ticker_symbol).sum(:quantity)
      @shares_sold = Transaction.where(user_id: session[:user_id], transaction_type: 'sell').group(:ticker_symbol).sum(:quantity)

      @price ={}
      @shares_owned.each do |stock|
        stockprice = HTTParty.get("http://marketdata.websol.barchart.com/getQuote.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbols=#{stock[0]}&type=daily&startDate=20160327")
        sprice = stockprice['results'][0]['lastPrice']
        @price[stock[0]]=sprice
      end

      @stockbalance = Transaction.where(user_id: session[:user_id], transaction_type: 'buy').sum(:quantity)

      @stock_owned = Transaction.where(user_id: session[:user_id], transaction_type: 'buy').group(:ticker_symbol).sum(:quantity)

      render "/transaction/index"
    end
  end

  def search
    @widget_symbol = params[:ticker]
    symbol = params[:ticker]

    @historical_result = HTTParty.get("http://marketdata.websol.barchart.com/getHistory.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbol=#{symbol}&type=daily&startDate=20160327")

      if !@historical_result
        errors[:flash] = ['Ticker not found']
        redirect_to "/"
      else
        @historical_result = HTTParty.get("http://marketdata.websol.barchart.com/getHistory.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbol=#{symbol}&type=daily&startDate=20160327000000")
      end

    @current_result =HTTParty.get("http://marketdata.websol.barchart.com/getQuote.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbols=#{symbol}")
      if @current_result.nil?
        flash[:errors] = ['Ticker not found']
        redirect_to "/"
      elsif @current_result['results'].nil?
        flash[:errors] = ['Ticker not found']
        redirect_to "/"
      elsif @current_result['results'][0].nil?
        flash[:errors] = ['Ticker not found']
        redirect_to "/"
      elsif @current_result['results'][0]['name'].nil?
        flash[:errors] = ['Ticker not found']
        redirect_to "/"
      else
        @current_result =HTTParty.get("http://marketdata.websol.barchart.com/getQuote.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbols=#{symbol}")
        render "/transaction/results"
    end
  end

  def account
    @withdrawable_cash = session[:user]['checking_account']
    render "account"
  end

  def purchase_stock
    if !session[:user]
      redirect_to "/login"
    else
      @user = User.find(session[:user_id])

      @portfolio_owned = Transaction.where(user_id: session[:user_id], transaction_type: 'buy').group(:user_id).sum(:trade_price)
      @portfolio_sold = Transaction.where(user_id: session[:user_id], transaction_type: 'sell').group(:user_id).sum(:trade_price)

      @stockbalance = Transaction.where(user_id: session[:user_id], transaction_type: 'buy').sum(:quantity)
      @ticker_follows = Ticker.all
      symbol = params[:ticker]
      @stockpurchase = HTTParty.get("http://marketdata.websol.barchart.com/getQuote.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbols=#{symbol}")

      @shares_owned = Transaction.where(user_id: session[:user_id], transaction_type: 'buy').group(:ticker_symbol).sum(:quantity)

      @shares_sold = Transaction.where(user_id: session[:user_id], transaction_type: 'sell').group(:ticker_symbol).sum(:quantity)

      @price ={}


      @shares_owned.each do |stock|
        stockprice = HTTParty.get("http://marketdata.websol.barchart.com/getQuote.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbols=#{stock[0]}&type=daily&startDate=20160327")
        sprice = stockprice['results'][0]['lastPrice']

        @price[stock[0]]=sprice

      end
    render "index"
    end
  end

  def sell_stock
    if !session[:user]
      redirect_to "/login"
    else
      @user = User.find(session[:user_id])
      @portfolio_owned = Transaction.where(user_id: session[:user_id], transaction_type: 'buy').group(:user_id).sum(:trade_price)
      @portfolio_sold = Transaction.where(user_id: session[:user_id], transaction_type: 'sell').group(:user_id).sum(:trade_price)

      @shares_owned = Transaction.where(user_id: session[:user_id], transaction_type: 'buy').group(:ticker_symbol).sum(:quantity)
      @shares_sold = Transaction.where(user_id: session[:user_id], transaction_type: 'sell').group(:ticker_symbol).sum(:quantity)

      @price ={}
      @shares_owned.each do |stock|
        stockprice = HTTParty.get("http://marketdata.websol.barchart.com/getQuote.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbols=#{stock[0]}&type=daily&startDate=20160327")
        sprice = stockprice['results'][0]['lastPrice']
        @price[stock[0]]=sprice
      end

      @ticker_follows = Ticker.all
      symbol = params[:ticker]

      @stocksell = HTTParty.get("http://marketdata.websol.barchart.com/getQuote.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbols=#{symbol}")
      render "index"
    end
  end

  def confirmation
    if params[:process] == "buy"
      @user = User.find(session[:user_id])
      @cost = params[:quantity].to_f * params[:price].to_f
      @funds = @user.checking_account - @cost
      @user.checking_account = @funds
      @user.save

      Transaction.create(user_id: session[:user_id], quantity: params[:quantity],current_price: params[:price],ticker_symbol: params[:ticker], transaction_type: 'buy', historic_price: params[:price].to_f , trade_price: @cost)
      redirect_to "/transaction/index"
    end

    if params[:process] == "sell"
      @user = User.find(session[:user_id])
      @proceeds = params[:quantity].to_f * params[:price].to_f
      @funds = @user.checking_account + @proceeds
      @user.checking_account = @funds
      @user.save

      @stocksold = Transaction.create(user_id: session[:user_id], quantity: params[:quantity],current_price: params[:price],ticker_symbol: params[:ticker],transaction_type: 'sell', historic_price: params[:price].to_f , trade_price: @proceeds)

    redirect_to "/transaction/index"
    end
  end

  def follow
    Ticker.create(user_id: session[:user_id], ticker_symbol: params[:ticker])
    redirect_to "/transaction/index"
  end

  def unfollow
    Ticker.delete(params[:id])
    redirect_to "/transaction/index"
  end
end
