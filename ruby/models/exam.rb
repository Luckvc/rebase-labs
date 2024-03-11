require_relative '../repositories/repository'

class Exam < Repository
  attr_accessor :id, :token, :date, :patient_id, :doctor_id

  def initialize(id:, token:, date:, patient_id:, doctor_id:)
    @id = id
    @token = token
    @date = date
    @patient_id = patient_id
    @doctor_id = doctor_id
  end

  def create_test(attributes, conn)
    result = conn.exec("INSERT INTO tests (#{attributes.keys.join(', ')}, exam_id)
                         VALUES (#{attributes.values.map{ |value| "'" + value.to_s + "'" }.join(', ')}, '#{@id}')
                         RETURNING *").entries[0]
    attributes = result.transform_keys { |k| k.to_sym }
    Test.new(**attributes)
  end

  def tests(conn)
    results = conn.exec("SELECT * FROM tests WHERE exam_id = '#{@id}'").entries
    if results
      results.map do |result|
        Test.create_object(result)
      end
    end
  end

  def hash_exam(conn)
    exam_hash = self.instance_attributes

    patient = Patient.find_by_id(exam_hash['patient_id'], conn)
    exam_hash.delete('patient_id')
    exam_hash['patient'] = patient.instance_attributes
    
    doctor = Doctor.find_by_id(exam_hash['doctor_id'], conn)
    exam_hash.delete('doctor_id')
    exam_hash['doctor'] = doctor.instance_attributes

    exam_hash['tests'] = self.tests(conn).map { |test| test.instance_attributes}
    exam_hash
  end
end