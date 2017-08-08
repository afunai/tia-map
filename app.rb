require 'sinatra'
require 'omniauth-twitter'
require 'json'

get '/' do
  '<a href="/auth/twitter">sign in with Twitter</a>'
end

get '/auth/:name/callback' do
  request.env.to_json
end
