# frozen_string_literal: true

require_relative '../repositories/repository'

class Doctor < Repository
  attr_accessor :id, :crm, :crm_state, :name, :email

  def initialize(**attributes)
    @id = attributes[:id]
    @crm = attributes[:crm]
    @crm_state = attributes[:crm_state]
    @name = attributes[:name]
    @email = attributes[:email]
  end

  def self.find_by_crm_and_state(crm, crm_state, conn)
    result = conn.exec("SELECT * FROM doctors WHERE crm = '#{crm}' AND crm_state = '#{crm_state}'").entries[0]
    return create_object(result) if result

    nil
  end

  def exams(conn)
    results = conn.exec("SELECT * FROM exams WHERE doctor_id = '#{@id}'").entries
    return unless results

    results.map do |result|
      Exam.create_object(result)
    end
  end
end
