# frozen_string_literal: true

require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_accessor :first, :last, :interim

  def initialize(first_station, last_station)
    @first = first_station
    @interim = []
    @last = last_station
    
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
