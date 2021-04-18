# frozen_string_literal: true

require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_accessor :first, :last, :interim

  def initialize(first_station, last_station)
    @first = first_station
    @interim = []
    @last = last_station

    validate!

    register_instance
  end

  def valid?
    validate!
  rescue StandardError
    false
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

  protected

  def validate!
    stations.each do |station|
      raise 'first, last and interim elements must be a Station instances' if station.class != Station
    end

    true
  end
end
