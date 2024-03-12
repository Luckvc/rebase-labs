require 'sinatra'
require 'pg'
require 'byebug'
require 'require_all'
require_all 'models'

dbname = ENV['RACK_ENV'] || 'development'
conn = PG.connect( dbname: dbname, host: 'postgres', user: 'admin', password: '123456' )
puts "connected to #{dbname} database" if conn

get '/tests' do
  content_type 'application/json'
  response.headers['Access-Control-Allow-Origin'] = '*'
  exams = Exam.all(conn)
  exams = exams.map {|exam| exam.hash_exam(conn)}
  exams.to_json
end

get '/hello' do
  'Hello world!'
end

get '/tests/:token' do
  content_type 'application/json'
  response.headers['Access-Control-Allow-Origin'] = '*'
  exam = Exam.find_by('token', params['token'], conn)
  return {}.to_json unless exam

  exam_hash = exam.hash_exam(conn)
  exam_hash.to_json
end