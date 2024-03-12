require 'sinatra'
require 'csv'
require 'pg'
require 'byebug'
require 'require_all'
require_all 'models'
require_relative 'db_connecter'


conn = DBConnecter.connect
puts "connected to #{conn.db} database" if conn

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

post '/import' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  csv = CSV.read(params[:file][:tempfile], col_sep:';')
  DataImporter.import_from_csv(csv)

  200
end