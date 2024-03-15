# frozen_string_literal: true

require 'sinatra'
require 'csv'
require 'pg'

require 'require_all'
require_all 'models'
require_all 'jobs'
require_relative 'services/db_connecter_service'
require_relative 'services/data_importer_service'

conn = DBConnecterService.connect
puts "connected to #{conn.db} database" if conn

get '/tests' do
  content_type 'application/json'
  response.headers['Access-Control-Allow-Origin'] = '*'
  exams = Exam.all(conn)
  exams = exams.map { |exam| exam.hash_exam(conn) }
  sorted_exams = exams.sort_by { |exam| exam['date'] }.reverse
  sorted_exams.to_json
end

get '/ping' do
  "Pong!\n"
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
  content_type 'application/json; charset=utf-8'
  unless File.extname(params['file']['tempfile']) == '.csv'
    response.body = 'Arquivo não suportado'
    return 415
  end

  csv = CSV.read(params['file']['tempfile'], col_sep: ';')
  ImportJob.perform_async(csv)

  response.body = 'Sua requisição está sendo processada'.to_json
  200
end
