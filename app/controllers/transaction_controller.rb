class TransactionController < ApplicationController

  def index
    if !session[:user]
      redirect_to "/login"
    else
    @ticker_follows = Ticker.all
    render "/transaction/index"
    end
  end

  def search
  symbol = params[:ticker]

    #HISTORICAL
    @historical_result = HTTParty.get("http://marketdata.websol.barchart.com/getHistory.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbol=#{symbol}&type=daily&startDate=20160327")

    if !@historical_result
      errors[:flash] = ['Ticker not found']
      redirect_to "/"
    else
      @historical_result = HTTParty.get("http://marketdata.websol.barchart.com/getHistory.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbol=#{symbol}&type=daily&startDate=20160327000000")
    end

    #GET QUOTE
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
    @ticker_follows = Ticker.all
    symbol = params[:ticker]
    @stockpurchase = HTTParty.get("http://marketdata.websol.barchart.com/getQuote.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbols=#{symbol}")
    render "index"
    end
  end

  def sell_stock
    if !session[:user]
      redirect_to "/login"
    else
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
      puts '/' * 50
      puts @cost

      @funds = @user.checking_account - @cost
      puts '/' * 50
      puts @funds

      @user.checking_account = @funds
      puts @user.checking_account
      @user.save

      Transaction.create(user_id: session[:user_id], quantity: params[:quantity],purchase_price: params[:price],ticker_symbol: params[:ticker])
    redirect_to "/transaction/index"
    end

    if params[:process] == "sell"

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
