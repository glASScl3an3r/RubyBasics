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
end