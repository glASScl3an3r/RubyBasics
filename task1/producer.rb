# frozen_string_literal: true

module Producer
  def producer=(prod)
    @prod = prod.to_s
  end

  def producer
    @prod
  end

  protected

  attr_accessor :prod
end
