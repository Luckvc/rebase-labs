require 'sinatra'
require 'pg'

get '/' do
  content_type 'text/html'
  File.open('index.html')
end

get '/exams' do
  content_type 'text/html'
  File.open('exams.html')
end