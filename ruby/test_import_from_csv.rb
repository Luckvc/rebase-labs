require 'csv'
require 'pg'

def import_from_csv
  conn = PG.connect( dbname: 'test', host: 'rblabs-postgres', user: 'postgres', password: '123456' )
  puts 'Connection stablished'
  conn.exec("CREATE TABLE IF NOT EXISTS tests ( id SERIAL PRIMARY KEY,
                                  patient_cpf VARCHAR(20) NOT NULL,
                                  patient_name VARCHAR(100) NOT NULL,
                                  patient_email VARCHAR(100) NOT NULL,
                                  patient_birthdate DATE NOT NULL,
                                  patient_address VARCHAR(100) NOT NULL,
                                  patient_city VARCHAR(100) NOT NULL,
                                  patient_state VARCHAR(20) NOT NULL,
                                  doctor_crm VARCHAR(10) NOT NULL,
                                  doctor_crm_state VARCHAR(20) NOT NULL,
                                  doctor_name VARCHAR(100) NOT NULL,
                                  doctor_email VARCHAR(100) NOT NULL,
                                  exam_token VARCHAR(100) NOT NULL,
                                  exam_date DATE NOT NULL,
                                  exam_type VARCHAR(100) NOT NULL,
                                  exam_limits VARCHAR(100) NOT NULL,
                                  exam_result VARCHAR(100) NOT NULL
                                  )")

  rows = CSV.read("./data.csv", col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end

  puts 'importing data...'
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
  puts 'data imported.'
  conn.close
end