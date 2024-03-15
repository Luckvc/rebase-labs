# frozen_string_literal: true

require_relative '../repositories/repository'

class Exam < Repository
  attr_accessor :id, :token, :date, :patient_id, :doctor_id

  def initialize(**attributes)
    @id = attributes[:id]
    @token = attributes[:token]
    @date = attributes[:date]
    @patient_id = attributes[:patient_id]
    @doctor_id = attributes[:doctor_id]
  end

  def create_test(attributes, conn)
    test_attributes = get_or_create_test_in_db(attributes, conn)

    test_attributes = test_attributes.transform_keys(&:to_sym)
    Test.new(**test_attributes)
  end

  def tests(conn)
    results = conn.exec("SELECT * FROM tests WHERE exam_id = '#{@id}'").entries
    return unless results

    results.map do |result|
      Test.create_object(result)
    end
  end

  def hash_exam(conn)
    exam_hash = instance_attributes

    patient = Patient.find_by_id(exam_hash['patient_id'], conn)
    exam_hash.delete('patient_id')
    exam_hash['patient'] = patient.instance_attributes

    doctor = Doctor.find_by_id(exam_hash['doctor_id'], conn)
    exam_hash.delete('doctor_id')
    exam_hash['doctor'] = doctor.instance_attributes

    exam_hash['tests'] = tests(conn).map(&:instance_attributes)
    exam_hash
  end

  def get_or_create_test_in_db(attributes, conn)
    conn.exec("SELECT * FROM tests WHERE type = '#{attributes['type']}' AND exam_id = '#{id}'").entries[0] ||
      conn.exec("INSERT INTO tests (#{attributes.keys.join(', ')}, exam_id)
                           VALUES (#{attributes.values.map { |value| "'#{value}'" }.join(', ')}, '#{@id}')
                           RETURNING *").entries[0]
  end
end
