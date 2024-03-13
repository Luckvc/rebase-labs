require 'sinatra'
require 'csv'
require 'pg'
require 'byebug'
require 'require_all'
require_all 'models'
require_all 'jobs'
require_relative 'db_connecter'
require_relative 'data_importer'


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
  content_type 'application/json'
  unless File.extname(params['file']['tempfile']) == '.csv'
    response.body = 'Arquivo não suportado'
    return 415
  end

  csv = CSV.read(params['file']['tempfile'], col_sep:';')
  ImportJob.perform_async(csv)
 
  response.body = 'Sua requisição está sendo processada'.to_json
  200
end