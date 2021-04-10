# frozen_string_literal: true

class Train
  attr_reader :serial, :speed, :type, :wagons

  TYPES = %i[passenger cargo].freeze

  def initialize(serial, type)
    @serial      = serial
    @speed       = 0.0
    @type        = (TYPES.include? type) ? type : nil
    @wagons      = []
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
