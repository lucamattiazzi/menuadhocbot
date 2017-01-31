require 'sinatra'
require 'dotenv'
Dotenv.load(".env")
configure do
  set :server, :puma
  set :port, 4568
end

API_AI_TOKEN = ENV["API_AI_TOKEN"]

require './requirements'

get '/' do
  erb :home, layout: :layout
end

post "/api/#{API_AI_TOKEN}" do
  message = JSON.parse(request.body.read)
  if message["originalRequest"]["data"].nil?
    response = "Mi spiace per ora funziono solo via Telegram!"
  elsif message["result"]["action"] == "richiesta_ricetta"
    response = RecipeRequestParser.new(message).parse
  elsif message["result"]["action"] == "fallback"
    response = FallbackParser.new(message).parse
  else
    response = "Mi spiace, non c'agg capit' nu cazz!"
  end
  content_type :json
  standard_response({
  "telegram": {
    "text": response,
    "parse_mode": "Markdown"
  }
})
end

error 400..510 do
  @x = (rand*100).round
  @y = (rand*100).round
  erb :sad_smile, layout: :layout
end

def standard_response(telegram_data)
  {
    "speech": "",
    "displayText": "",
    "data": telegram_data,
    "contextOut": [],
    "source": "mah_bot"
  }.to_json
end
