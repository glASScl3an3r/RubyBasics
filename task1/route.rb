# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'
require_relative 'station'

class Route
  include InstanceCounter
  include Validation

  validate :first, :type, Station
  validate :last, :type, Station
  validate :interim, :type, Array

  attr_reader :first, :last

  def initialize(first_station, last_station)
    @first = first_station
    @interim = []
    @last = last_station

    validate!

    register_instance
  end

  def add_station(station)
    @interim.push(station)
  end

  def delete_station(station)
    @interim.delete(station)
  end

  def stations
    [@first] + @interim + [@last]
  end
end
