#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :main
end

