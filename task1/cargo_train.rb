# frozen_string_literal: true

require_relative 'train'
require_relative 'cargo_wagon'

class CargoTrain < Train
  def initialize(serial)
    super(serial, :cargo)
  end

  def add_wagon(wagon)
    return nil if wagon.type != :cargo

    @wagons.push(wagon)
  end
end
