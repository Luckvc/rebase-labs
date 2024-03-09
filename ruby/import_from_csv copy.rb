require 'csv'
require 'pg'
require 'require_all'
require_all 'models'

def import_from_csv
  dbname = ENV['RACK_ENV'] || 'development'
  conn = PG.connect(dbname: dbname, host: 'postgres', user: 'admin', password: '123456')

  rows = CSV.read("data.csv", col_sep: ';')

  rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      acc[idx] = cell
    end
  end

  puts 'importing data...' unless ENV['RACK_ENV'] == 'test'

  rows.each do |row|
    exam_attributes = {}
    exam_attributes['token'], exam_attributes['date'] = rows[0][11..12]
    exam = Exam.find_by('token', exam_attributes['token'], conn)

    if exam
      test_attributes = {}
      test_attributes['type'], test_attributes['limits'], test_attributes['result'] = rows[0][13..15]
      exam.create_test(test_attributes, conn)
    else
      patient_attributes = {}
      patient_attributes['cpf'], patient_attributes['name'], patient_attributes['email'], patient_attributes['birthdate'],
      patient_attributes['address'], patient_attributes['city'], patient_attributes['state'] = rows[0][0..6]

      doctor_attributes = {}
      doctor_attributes['crm'], doctor_attributes['crm_state'], doctor_attributes['name'], doctor_attributes['email'] = rows[0][7..10]

      patient_id = Patient.find_by('cpf', patient_attributes['cpf'], conn).id || 
                   Patient.create(patient_attributes, conn).id

      doctor_id = Doctor.find_by(doctor_attributes['crm'], doctor_attributes['crm-state'], conn).id || 
                  Doctor.create(doctor_attributes, conn).id

      exam_attributes['patient_id'], exam_attributes['doctor_id'] = patient_id, doctor_id

      exam = Exam.create(exam_attributes, conn)

      test_attributes = {}
      test_attributes['type'], test_attributes['limits'], test_attributes['result'] = rows[0][13..15]
      exam.create_test(test_attributes, conn)
    end
  end
  
  puts 'data imported.' unless ENV['RACK_ENV'] == 'test'
  conn.close
end

import_from_csv

conn.exec("TRUNCATE TABLE patients, doctors, exams, tests")