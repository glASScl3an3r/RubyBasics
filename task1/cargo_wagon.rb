# frozen_string_literal: true

require_relative 'wagon'

class CargoWagon < Wagon
  def type
    :cargo
  end
end
