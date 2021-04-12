# frozen_string_literal: true

require_relative 'train'
require_relative 'passenger_wagon'

class PassengerTrain < Train
  def type
    :passenger
  end
end
