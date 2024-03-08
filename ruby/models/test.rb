require_relative '../repositories/repository'

class Test < Repository
  attr_accessor :type, :limits, :result

  def initializer(type, limits, result)
    @type = type
    @limits = limits
    @result = result
  end
end