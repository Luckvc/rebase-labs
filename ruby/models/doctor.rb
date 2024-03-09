require_relative '../repositories/repository'

class Doctor < Repository
  attr_accessor :id, :crm, :crm_state, :name, :email

  def initialize(id:, crm:, crm_state:, name:, email:)
    @id = id
    @crm = crm
    @crm_state = crm_state
    @name = name
    @email = email
  end

  def self.find_by(crm, crm_state, conn)
    result = conn.exec("SELECT * FROM doctors WHERE crm = '#{crm}' AND crm_state = '#{crm_state}'").entries[0]
    create_object(result) if result
  end
  
  def exams
    conn.exec("SELECT * FROM exams WHERE doctor_id = '#{@id}'").entries
  end
end