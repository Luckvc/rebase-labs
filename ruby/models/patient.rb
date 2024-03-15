# frozen_string_literal: true

require_relative '../repositories/repository'

class Patient < Repository
  attr_accessor :id, :cpf, :name, :email, :birthdate, :address, :city, :state

  def initialize(**attributes)
    @id = attributes[:id]
    @cpf = attributes[:cpf]
    @name = attributes[:name]
    @email = attributes[:email]
    @birthdate = attributes[:birthdate]
    @address = attributes[:address]
    @city = attributes[:city]
    @state = attributes[:state]
  end

  def exams(conn)
    results = conn.exec("SELECT * FROM exams WHERE patient_id = '#{@id}'").entries
    return unless results

    results.map do |result|
      Exam.create_object(result)
    end
  end
end
