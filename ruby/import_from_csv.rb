require 'csv'
require 'pg'
require 'require_all'
require_all 'models'

def import_from_csv
  # dbname = ENV['RACK_ENV'] || 'development'
  # conn = PG.connect(dbname: dbname, host: 'postgres', user: 'admin', password: '123456')
  conn = PG.connect(dbname: 'test', host: 'postgres', user: 'admin', password: '123456')

  rows = CSV.read("./spec/support/test_data.csv", col_sep: ';')

  rows.shift
  columns = ['patient_cpf',
             'patient_name',
             'patient_email',
             'patient_birthdate',
             'patient_address',
             'patient_city',
             'patient_state',
             'doctor_crm',
             'doctor_crm_state',
             'doctor_name',
             'doctor_email',
             'exam_token',
             'exam_date',
             'exam_type',
             'exam_limits',
             'exam_result']

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end

  puts 'importing data...' unless ENV['RACK_ENV'] == 'test'

  rows.each do |row|

      patient_attributes['cpf'] = row[0]
      patient_attributes['name'] = row[1]
      patient_attributes['email'] = row[2]
      patient_attributes['birthdate'] = row[3]
      patient_attributes['address'] = row[4]
      patient_attributes['city'] = row[5]
      patient_attributes['state'] = row[6]
      doctor_attributes['crm'] = row[7]
      doctor_attributes['crm_state'] = row[8]
      doctor_attributes['name'] = row[9]
      doctor_attributes['email'] = row[10]
      test_attributes['type'] = row[13]
      test_attributes['limits'] = row[14]
      test_attributes['result'] = row[15]
      
      
      
    exam_attributes['token'] = row[11]
    if Exam.find_by('token', exam_attributes['token'], conn)
      exam_attributes['date'] = row[12]
      #adiciona o teste
    else
      #Find or create patient
      #Find or create Doctor
      #Create exam
      #Create test
    end

  #  conn.exec("INSERT INTO tests (patient_cpf, 
  #                                patient_name, 
  #                                patient_email, 
  #                                patient_birthdate, 
  #                                patient_address, 
  #                                patient_city, 
  #                                patient_state, 
  #                                doctor_crm, 
  #                                doctor_crm_state, 
  #                                doctor_name, 
  #                                doctor_email, 
  #                                exam_token, 
  #                                exam_date, 
  #                                exam_type, 
  #                                exam_limits, 
  #                                exam_result) 
  #            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)", row)
  end
  puts 'data imported.' unless ENV['RACK_ENV'] == 'test'
  conn.close
end

import_from_csv