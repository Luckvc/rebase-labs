require 'sinatra'
require 'pg'
require 'byebug'

conn = PG.connect( dbname: 'postgres', host: 'rblabs-postgres', user: 'postgres', password: '123456' )

get '/tests' do
  content_type 'application/json'
  result = conn.exec("SELECT * FROM tests;").to_a
  result.to_json
end

get '/hello' do
  'Hello world!'
end
