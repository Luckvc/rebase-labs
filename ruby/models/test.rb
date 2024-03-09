require_relative '../repositories/repository'

class Test < Repository
  attr_accessor :id, :type, :limits, :result, :exam_id

  def initialize(id:, type:, limits:, result:, exam_id:)
    @id = id
    @type = type
    @limits = limits
    @result = result
    @exam_id = exam_id
  end
end