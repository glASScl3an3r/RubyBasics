# frozen_string_literal: true

require_relative 'wagon'
require_relative 'validation'

class PassengerWagon < Wagon
  include Validation

  validate :seats_count, Integer
  validate :seats_busy, Integer

  def type
    :passenger
  end

  def initialize(seats_count)
    @seats_count = seats_count
    @seats_busy = 0

    validate!
  end

  def take_seat
    @seats_busy += 1 if @seats_busy < @seats_count
  end

  def free_seats
    @seats_count - @seats_busy
  end

  def busy_seats
    @seats_busy
  end
end
