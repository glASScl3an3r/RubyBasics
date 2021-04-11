# frozen_string_literal: true

require_relative 'train'
require_relative 'cargo_wagon'

class CargoTrain < Train
  def type
    :cargo
  end
end
