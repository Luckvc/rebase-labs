require 'sinatra'
require 'pg'

dbname = ENV['RACK_ENV'] || 'development'
conn = PG.connect( dbname: dbname, host: 'rblabs-postgres', user: 'admin', password: '123456' )
puts "conected to #{dbname} database" if conn

get '/tests' do
  content_type 'application/json'
  response.headers['Access-Control-Allow-Origin'] = '*'
  result = conn.exec("SELECT * FROM tests;").to_a
  result.to_json
end

get '/hello' do
  'Hello world!'
end
