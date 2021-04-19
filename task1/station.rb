# frozen_string_literal: true

require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []

    validate!

    register_instance
  end

  def valid?
    validate!
  rescue StandardError
    false
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

  protected

  def validate!
    raise 'name must be a string' if @name.class != String

    @trains.each do |train|
      raise 'trains elements must be a Train instances' if train.class != Train
    end

    true
  end
end
