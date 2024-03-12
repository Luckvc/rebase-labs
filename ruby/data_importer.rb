require 'csv'
require 'byebug'
require 'require_all'
require_all 'models'
require_relative 'db_connecter'

class DataImporter
  def self.import_from_csv
    @conn = DBConnecter.connect
    rows = readRows

    puts 'importing data...' unless ENV['RACK_ENV'] == 'test'
    populate_db(rows)
    puts 'data imported.' unless ENV['RACK_ENV'] == 'test'

    @conn.close
  end

  private

  def self.readRows
    rows = CSV.read("data.csv", col_sep: ';')
    rows.shift
    rows.map do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        acc[idx] = cell
      end
    end

    rows
  end

  def self.populate_db(rows)
    rows.each do |row|
      exam = get_exam(row)
      next build_test(exam, row) if exam

      patient = set_patient(row)
      doctor = set_doctor(row)
      @exam_attributes['patient_id'], @exam_attributes['doctor_id'] = patient.id, doctor.id
      exam = Exam.create(@exam_attributes, @conn)
      build_test(exam, row)
    end
  end

  def self.get_exam(attributes)
    @exam_attributes = {}
    @exam_attributes['token'], @exam_attributes['date'] = attributes[11..12]
    Exam.find_by('token', @exam_attributes['token'], @conn)
  end

  def self.set_patient(attributes)
    patient_attributes = {}
    patient_attributes['cpf'], patient_attributes['name'], patient_attributes['email'], patient_attributes['birthdate'],
    patient_attributes['address'], patient_attributes['city'], patient_attributes['state'] = attributes[0..6]

    Patient.find_by('cpf', patient_attributes['cpf'], @conn) || Patient.create(patient_attributes, @conn)
  end

  def self.set_doctor(attributes)
    doctor_attributes = {}
    doctor_attributes['crm'], doctor_attributes['crm_state'], doctor_attributes['name'], doctor_attributes['email'] = attributes[7..10]

    Doctor.find_by_crm_and_state(doctor_attributes['crm'], doctor_attributes['crm_state'], @conn) || 
                Doctor.create(doctor_attributes, @conn)
  end

  def self.build_test(exam, attributes)
    test_attributes = {}
    test_attributes['type'], test_attributes['limits'], test_attributes['result'] = attributes[13..15]
    exam.create_test(test_attributes, @conn)
  end
end