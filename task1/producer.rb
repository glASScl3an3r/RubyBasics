# frozen_string_literal: true

module Producer
  def producer=(prod)
    self.prod = prod
  end

  def producer
    prod
  end

  protected

  attr_accessor :prod
end
