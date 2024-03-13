require 'sinatra'
require 'pg'

get '/' do
  content_type 'text/html'
  File.open('index.html')
end