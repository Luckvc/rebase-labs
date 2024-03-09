require_relative '../repositories/repository'

class Patient < Repository
  attr_accessor :cpf, :name, :email, :birthdate, :address, :city, :state

  def initialize(cpf, name, email, birthdate, address, city, state)
    @cpf = cpf
    @name = name
    @email = email
    @birthdate = birthdate
    @address = address
    @city = city
    @state = state
    @exams = []
  end
end

