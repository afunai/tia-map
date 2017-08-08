require 'sinatra'
require 'omniauth-twitter'
require 'json'

use OmniAuth::Builder do
  provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
end

get '/' do
  '<a href="/auth/twitter">sign in with Twitter</a>'
end

get '/auth/:name/callback' do
  request.env.to_json
end
