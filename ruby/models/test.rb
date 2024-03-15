# frozen_string_literal: true

require_relative '../repositories/repository'

class Test < Repository
  attr_accessor :id, :type, :limits, :result, :exam_id

  def initialize(**attributes)
    @id = attributes[:id]
    @type = attributes[:type]
    @limits = attributes[:limits]
    @result = attributes[:result]
    @exam_id = attributes[:exam_id]
  end
end
