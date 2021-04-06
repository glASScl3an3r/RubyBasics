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

  def length
    2 + @interim.count
  end

  def station(index)
    cnt = @interim.length
    if index.negative?
      nil
    elsif index.zero?
      @first
    elsif index <= cnt
      @interim[index - 1]
    elsif index == cnt + 1
      @last
    end
  end
end

class Train
  attr_reader :serial, :speed, :type, :wagon_count

  module Types
    PASSENGER = 0
    CARGO = 1
  end

  def initialize(serial, type, wagon_count)
    @serial          = serial
    @type            = type
    @speed           = 0.0
    @wagon_count     = wagon_count
    @route           = nil
    @current_station = -1
  end

  def go_next
    if @route
      throw 'train was on the last station' if @current_station + 1 == @route.length

      prev_station = @route.station(@current_station)
      prev_station&.delete_train(self)
      @current_station += 1
      next_station = @route.station(@current_station)
      next_station&.add_train(self)
    else
      throw "Train #{serial} has no route"
    end
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
    @current_station = -1
    go_next # go to the first station
  end

  def prev_station
    @route.station(@current_station - 1)
  end

  def next_station
    @route.station(@current_station + 1)
  end

  def current_station
    @route.station(@current_station)
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
    throw 'trains length was 0' if @trains.length.zero?

    current_train = @trains[0]
    @trains.shift
    current_train.go_next
  end
end