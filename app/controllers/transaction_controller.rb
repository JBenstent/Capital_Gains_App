class TransactionController < ApplicationController

  def index
  render "/transaction/purchase"
  end

  def search



    symbol = params[:ticker]



    #HISTORICAL
    @historical_result = HTTParty.get("http://marketdata.websol.barchart.com/getHistory.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbol=#{symbol}&type=daily&startDate=20160327000000")

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
end
