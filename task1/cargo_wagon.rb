# frozen_string_literal: true

require_relative 'wagon'
require_relative 'validation'

class CargoWagon < Wagon
  include Validation

  validate :max_volume, :type, Float
  validate :used_volume, :type, Float

  def type
    :cargo
  end

  def initialize(max_volume)
    @max_volume = max_volume
    @used_volume = 0.0

    validate!
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
end
