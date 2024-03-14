require 'sinatra'
require 'pg'
require 'faraday'
require 'faraday/multipart'
require 'byebug'

get '/' do
  content_type 'text/html'
  File.open('index.html')
end


get '/tests' do
  content_type 'application/json'
  response = Faraday.get('http://backend:9292/tests')
  response.body
end

get '/tests/:token' do
  content_type 'application/json'
  response = Faraday.get("http://backend:9292/tests/#{params[:token]}")
  response.body
end

post '/import' do
  content_type 'application/json; charset=utf-8'
  connection = Faraday.new(url: 'http://backend:9292') do |conn|
    conn.request :multipart
    conn.request :url_encoded
    conn.adapter Faraday.default_adapter
  end

  parameters = { file: Faraday::UploadIO.new(params['file']['tempfile'], 'text/csv') }

  response = connection.post('/import', parameters)

  response.body
end