require 'sinatra'
require 'pg'

conn = PG.connect( dbname: 'postgres', host: 'rblabs-postgres', user: 'postgres', password: '123456' )

get '/tests' do
  content_type :json
  result = conn.exec("SELECT * FROM tests;").to_a
  result.to_json
end

get '/hello' do
  'Hello world!'
end
