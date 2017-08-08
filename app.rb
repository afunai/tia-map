require 'sinatra'
require 'omniauth-twitter'
require 'twitter'
require 'erb'

use OmniAuth::Builder do
  provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
end

enable :sessions

get '/' do
  redirect '/auth/twitter' unless session[:credentials]

  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = session[:credentials]['token']
    config.access_token_secret = session[:credentials]['secret']
  end

  friends = []
  client.friend_ids.each_slice(200) do |slice|
    client.users(slice).each do |f|
      friends << f.name
    end
  end

  @spaces = {}
  friends.each do |f|
    if f !~ /(C\d\d|日目)/i and f =~ /(.+?)([\[\(@＠%↑\/【（☻■●・。1$]|comitia|tia|コミティア|ティア).*([A-ZＡ-Ｚあ-ん])(\d\d[abａｂ]?)/i then
      @spaces["#{$3.upcase}-#{$4}"] = '★' + $1.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
    end
  end
  erb :map
end

get '/auth/:name/callback' do
  session[:credentials] = env['omniauth.auth'][:credentials].to_h
  redirect '/'
end
