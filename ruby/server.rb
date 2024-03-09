require 'sinatra'
require 'pg'
require 'byebug'
require 'require_all'
require_all 'models'

dbname = ENV['RACK_ENV'] || 'development'
conn = PG.connect( dbname: dbname, host: 'postgres', user: 'admin', password: '123456' )
puts "conected to #{dbname} database" if conn

get '/tests' do
  content_type 'application/json'
  response.headers['Access-Control-Allow-Origin'] = '*'
  exams = Exam.all(conn)
  exams = exams.map do |exam|
    exam_hash = exam.instance_attributes

    patient = Patient.find_by_id(exam_hash['patient_id'], conn)
    exam_hash.delete('patient_id')
    exam_hash['patient'] = patient.instance_attributes
    
    doctor = Doctor.find_by_id(exam_hash['doctor_id'], conn)
    exam_hash.delete('doctor_id')
    exam_hash['doctor'] = doctor.instance_attributes

    exam_hash['tests'] = exam.tests(conn)
    exam_hash
  end
  exams.to_json
end

get '/hello' do
  'Hello world!'
end