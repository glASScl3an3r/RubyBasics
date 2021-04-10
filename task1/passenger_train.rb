# frozen_string_literal: true

require_relative 'train'
require_relative 'passenger_wagon'

class PassengerTrain < Train
  def initialize(serial)
    super(serial, :passenger)
  end

  def add_wagon(wagon)
    @wagons.push(wagon) if wagon.type != :passenger
  end
end
