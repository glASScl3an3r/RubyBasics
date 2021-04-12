module Producer
  def producer=(prod)
    self.prod = prod
  end

  def producer
    self.prod
  end

  protected
  attr_accessor :prod
end