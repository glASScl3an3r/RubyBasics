# frozen_string_literal: true

class Route
  attr_accessor :first, :last, :interim

  def initialize(first_station, last_station)
    @first = first_station
    @interim = []
    @last = last_station
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

  def count
    2 + @interim.count
  end
end

class Train
  attr_reader :serial, :speed, :type, :wagon_count

  # the easiest way to implement enums that i found
  module Types
    PASSENGER = Class.new
    CARGO = Class.new
  end

  def initialize(serial, type, wagon_count)
    @serial      = serial
    @type        = type
    @speed       = 0.0
    @wagon_count = wagon_count
  end

  def go_next
    return unless next_station

    current_station.delete_train(self)
    @current_station_index += 1
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

  def add_wagon
    throw "Train #{serial} was running" if running

    @wagon_count += 1
  end

  def remove_wagon
    throw "Train #{serial} was running" if running

    throw "Train #{serial} had 0 wagons" if @wagon_count.zero?

    @wagon_count -= 1
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
    return nil if @current_station_index >= @route.count - 1

    @route.stations[@current_station_index + 1]
  end

  def current_station
    @route.stations[@current_station_index]
  end
end

class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains.push(train)
  end

  def delete_train(train)
    @trains.delete(train)
  end

  def trains(type = nil)
    return @trains if type.nil?

    trains_to_return = []

    @trains.each do |train|
      trains_to_return.push(train) if train.type == type
    end

    trains_to_return
  end

  def send_train
    current_train = @trains[0]
    @trains.shift
    current_train.go_next
  end
end
