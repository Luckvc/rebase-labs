require_relative '../repositories/repository'

class Exam < Repository
  attr_accessor :token, :date

  def initialize(token, date)
    @token = token
    @date = date
    @tests = []
  end
end