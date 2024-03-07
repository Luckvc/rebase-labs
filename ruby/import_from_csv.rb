require 'csv'
require 'pg'

def import_from_csv
  dbname = ENV['RACK_ENV'] || 'development'
  conn = PG.connect(dbname: dbname, host: 'rblabs-postgres', user: 'admin', password: '123456')

  rows = CSV.read("data.csv", col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end

  puts 'importing data...' unless ENV['RACK_ENV'] == 'test'
  rows.each do |row|
    conn.exec("INSERT INTO tests (patient_cpf, 
                                  patient_name, 
                                  patient_email, 
                                  patient_birthdate, 
                                  patient_address, 
                                  patient_city, 
                                  patient_state, 
                                  doctor_crm, 
                                  doctor_crm_state, 
                                  doctor_name, 
                                  doctor_email, 
                                  exam_token, 
                                  exam_date, 
                                  exam_type, 
                                  exam_limits, 
                                  exam_result) 
              VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)", row)
  end
  puts 'data imported.' unless ENV['RACK_ENV'] == 'test'
  conn.close
end

import_from_csv