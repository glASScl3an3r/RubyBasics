# frozen_string_literal: true

require_relative 'wagon'

class CargoWagon < Wagon
  def type
    :cargo
  end

  def initialize(max_volume)
    @max_volume = max_volume
    @used_volume = 0.0

    validate!
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  def take_volume(volume)
    @used_volume = [@used_volume + volume, @max_volume].min
  end

  def free_volume
    @max_volume - @used_volume
  end

  def occupied_volume
    @used_volume
  end

  protected

  attr_accessor :max_volume, :used_volume

  def validate!
    raise "max_volume must be a float" if @max_volume.class != Float
    raise "used_volume cant be less then zero" if @used_volume.negative?
    raise "used_volume cant be greater then max_volume" if @used_volume > @max_volume
    true
  end
end
