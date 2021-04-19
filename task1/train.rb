# frozen_string_literal: true

require_relative 'producer'
require_relative 'instance_counter'

class Train
  include Producer
  include InstanceCounter

  attr_reader :serial, :speed, :wagons

  def self.find(serial)
    all.detect { |train| train.serial == serial }
  end

  def initialize(serial)
    @serial      = serial
    @speed       = 0.0
    @wagons      = []

    validate!

    register_instance
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  def add_wagon(wagon)
    @wagons.push(wagon) if !running? && wagon.type == type
  end

  def go_next
    return unless next_station

    current_station.delete_train(self)
    @current_station_index += 1
    current_station.add_train(self)
  end

  def go_back
    return unless prev_station

    current_station.delete_train(self)
    @current_station_index -= 1
    current_station.add_train(self)
  end

  def running?
    @speed != 0.0
  end

  def add_velocity(delta_v)
    @speed += delta_v
  end

  def stop
    @speed = 0.0
  end

  def remove_wagon(index)
    @wagons.delete_at(index) unless running?
  end

  def route=(route)
    @route = route
    @route.first.add_train(self)
    @current_station_index = 0
  end

  def prev_station
    # if we are in the first station
    return nil if @current_station_index <= 0

    @route.stations[@current_station_index - 1]
  end

  def next_station
    # if we are in the last station
    return nil if @current_station_index >= @route.stations.count - 1

    @route.stations[@current_station_index + 1]
  end

  def current_station
    @route.stations[@current_station_index]
  end

  protected

  def validate!
    # 3 chars or digits then nothing or - then 2 chars or digits
    regexp = /\A[0-9A-Za-z]{3}-{0,1}[0-9A-Za-z]{2}\z/

    raise 'serial must be a string' if @serial.class != String

    if @serial !~ regexp
      raise 'serial must be 3 digits or characters '\
            'followed by an optional dash then 2 characters or digits. '\
            'Examples: ab1-a2, 1b1as'
    end

    @wagons.each do |wagon|
      raise 'wagons must be of the same type as trains' if wagon.type != type
    end

    true
  end
end
