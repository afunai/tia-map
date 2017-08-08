require 'sinatra'
require 'omniauth-twitter'
require 'twitter'
require 'json'

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
end

get '/' do
  '<a href="/auth/twitter">sign in with Twitter</a>'
end

get '/auth/:name/callback' do
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = env['omniauth.auth'][:credentials][:token]
    config.access_token_secret = env['omniauth.auth'][:credentials][:secret]
  end

  friends = []
  client.friend_ids.each_slice(100) do |slice|
    friends << client.users(slice).collect do |f|
      f.name
    end
  end
  friends.inspect
end
