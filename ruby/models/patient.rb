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

  def exams(conn)
    results = conn.exec("SELECT * FROM exams WHERE patient_id = '#{@id}'").entries
    if results
      results.map do |result|
        Exam.create_object(result)
      end
    end
  end
end

