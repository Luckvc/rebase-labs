require 'sinatra'
require 'pg'
require 'byebug'

conn = PG.connect( dbname: 'postgres', host: 'rblabs-postgres', user: 'postgres', password: '123456' )

get '/tests' do
  content_type :json
  byebug
  puts conn.exec("SELECT * FROM tests;").to_a
  'Hello world!'
end

get '/hello' do
  'Hello world!'
end
