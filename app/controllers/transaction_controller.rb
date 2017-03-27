class TransactionController < ApplicationController

  def index
  render "/transaction/purchase"
  end

  def search
    symbol= params[:ticker]

    #HISTORICAL
    @historical_result = HTTParty.get("http://marketdata.websol.barchart.com/getHistory.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbol=#{symbol}&type=daily&startDate=20160327000000")

    #GET QUOTE
    @current_result =
    HTTParty.get("http://marketdata.websol.barchart.com/getQuote.json?key=c259a86b4ec1a63d89b1dcc5173c24c1&symbols=#{symbol}")
    render "/transaction/results"
  end
end
