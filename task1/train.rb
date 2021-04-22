# frozen_string_literal: true

require_relative 'producer'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Train
  include Producer
  include InstanceCounter
  include Validation
  include Accessors

  strong_attr_accessor :serial, String
  attr_reader :speed, :wagons, :serial

  validate :serial, :type, String
  validate :serial, :presence
  validate :serial, :format, /\A[0-9A-Za-z]{3}-{0,1}[0-9A-Za-z]{2}\z/
  validate :speed, :type, Float

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

  def foreach_wagon(&block)
    @wagons.each(&block)
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
end
