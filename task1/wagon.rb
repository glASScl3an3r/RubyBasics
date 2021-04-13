# frozen_string_literal: true

require_relative 'producer'

class Wagon
  include Producer
  
  def type
    nil
  end
end
