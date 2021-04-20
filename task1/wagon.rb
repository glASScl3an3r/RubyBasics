# frozen_string_literal: true

require_relative 'producer'

class Wagon
  include Producer

  def valid?
    validate!
  rescue StandardError
    false
  end
end
