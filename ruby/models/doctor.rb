require_relative '../repositories/repository'

class Doctor < Repository
  attr_accessor :crm, :crm_state, :name, :email

  def initializer(crm, crm_state, name, email)
    @crm = crm
    @crm_state = crm_state
    @name = name
    @email = email
  end
end