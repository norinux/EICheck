#!/usr/bin/env ruby
require "sinatra/config_file"
require 'bundler'
Bundler.require
require 'sinatra'
require 'sinatra/reloader'
require 'google_drive'
require 'oauth2'
require 'logger'
 
logger = Logger.new('log/sinatra.log')
config_file 'lib/config/config.yml'

get '/' do
  erb :main
end

get '/check' do
  erb :check
end

get '/done' do
  erb :done
end

def show_spreadsheet
  client_id     = settings.CLIENT_ID
  client_secret = settings.CLIENT_SECRET
  refresh_token = settings.REFRESH_TOKEN

  client = OAuth2::Client.new(
    client_id,
    client_secret,
    site: "https://accounts.google.com",
    token_url: "/o/oauth2/token",
    authorize_url: "/o/oauth2/auth")
  auth_token = OAuth2::AccessToken.from_hash(client,{:refresh_token => refresh_token, :expires_at => 3600})
  auth_token = auth_token.refresh!
  session = GoogleDrive.login_with_oauth(auth_token.token)
  ws = session.spreadsheet_by_key(settings.SPREAD_SHEET_KEY).worksheets[0]

  # 追記レコード位置
  nws = ws.num_rows+1
  # レコードを記録
  ws[nws,1] = DateTime.now.strftime("%Y/%m/%d %H:%M:%S")
  ws[nws,2] = "wine" #選択されたボタンによって分岐予定
  ws[nws,3] = "hoge" #ICカードの番号予定
  ws.save
end

show_spreadsheet
