require 'sinatra'
require 'pg'
require 'byebug'

dbname = ENV['RACK_ENV']
conn = PG.connect( dbname: dbname, host: 'rblabs-postgres', user: 'admin', password: '123456' )

get '/tests' do
  puts dbname
  content_type 'application/json'
  result = conn.exec("SELECT * FROM tests;").to_a
  result.to_json
end

get '/hello' do
  'Hello world!'
end
