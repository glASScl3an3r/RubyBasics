# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Station
  include Validation
  include InstanceCounter
  include Accessors

  validate :name, String
  attr_accessor_with_history :name

  def initialize(station_name)
    @name = station_name
    @trains = []

    validate!

    register_instance
  end

  def foreach_train(type, &block)
    trains(type).each(&block)
  end

  def add_train(train)
    @trains.push(train)
  end

  def delete_train(train)
    @trains.delete(train)
  end

  def trains(type = nil)
    return @trains if type.nil?

    @trains.select { |train| train.type == type }
  end

  def send_train
    current_train = @trains[0]
    @trains.shift
    current_train.go_next
  end
end
