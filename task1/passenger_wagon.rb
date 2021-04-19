# frozen_string_literal: true

require_relative 'wagon'

class PassengerWagon < Wagon
  def type
    :passenger
  end

  def initialize(seats_count)
    @seats_count = seats_count
    @seats_busy = 0

    validate!
  end

  def valid?
    validate!
  rescue StandardError
    false
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

  protected

  attr_accessor :seats_count, :seats_busy

  def validate!
    raise "seats_count must be an Integer" if @seats_count.class != Integer
    raise "seats_count must be greater then 0" if @seats_count <= 0
    raise "seats_busy cant be greater then seats_count" if @seats_busy > @seats_count
    true
  end
end