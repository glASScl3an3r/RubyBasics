# frozen_string_literal: true

require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []

    register_instance
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
