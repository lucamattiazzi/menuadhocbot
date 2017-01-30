require 'sinatra'
require 'dotenv'
Dotenv.load(".env")
configure do
  set :server, :puma
  set :port, 4568
end

API_TOKEN = ENV["API_TOKEN"]

require './requirements'

get '/' do
  x = (rand*100).round
  y = (rand*100).round
  smile = "<span style='position:absolute; top:#{y}%; left: #{y}%;transform: rotate(90.0deg);font-family: sans-serif'>:-)</span>"
  @s = (rand > 0.99) ? smile : ""
  erb :home, layout: :layout
end

post "/api/#{API_TOKEN}" do
  message = JSON.parse(request.body.read)
  if message["originalRequest"]["data"].present?
    username = TelegramMessage.new(message["originalRequest"]["data"]["message"]).save_and_return
  else
    username = "TizioCaio"
  end
  if message["result"]["action"] == "richiesta_ricetta"
    result = RequestParser.new(username, message["result"]["parameters"]).parse
    content_type :json
    standard_response(result)
  end
end

error 400..510 do
  @x = (rand*100).round
  @y = (rand*100).round
  erb :sad_smile, layout: :layout
end

def standard_response(speech)
  {
    "speech": speech,
    "displayText": speech,
    "contextOut": [],
    "source": "botess"
  }.to_json
end
