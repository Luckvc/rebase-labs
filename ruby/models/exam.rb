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
    conn.exec("SELECT * FROM tests WHERE exam_id = '#{@id}'").entries
  end
end