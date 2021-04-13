# frozen_string_literal: true

require_relative 'producer'
require_relative 'instance_counter'

class Train
  include Producer
  include InstanceCounter

  attr_reader :serial, :speed, :wagons

  def self.find(serial)
    all.detect {|train| train.serial == serial }
  end

  def initialize(serial)
    @serial      = serial
    @speed       = 0.0
    @wagons      = []

    register_instance
  end

  def type
    nil
  end

  def add_wagon(wagon)
    @wagons.push(wagon) if wagon.type != type
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

  def running
    @speed != 0.0
  end

  def add_velocity(delta_v)
    @speed += delta_v
  end

  def stop
    @speed = 0.0
  end

  def add_wagon(_wagon)
    nil
  end

  def remove_wagon(index)
    @wagons.delete_at(index)
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
end
