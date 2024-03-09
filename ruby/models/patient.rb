require_relative '../repositories/repository'

class Patient < Repository
  attr_accessor :id, :cpf, :name, :email, :birthdate, :address, :city, :state

  def initialize(id:, cpf:, name:, email:, birthdate:, address:, city:, state:)
    @id = id
    @cpf = cpf
    @name = name
    @email = email
    @birthdate = birthdate
    @address = address
    @city = city
    @state = state
  end

  def patient_exams
  end
end

