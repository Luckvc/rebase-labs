require 'sinatra'
require 'pg'

get '/index' do
  content_type 'text/html'
  File.open('index.html')
end