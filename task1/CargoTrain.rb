require_relative 'Train'
require_relative 'CargoWagon'

class CargoTrain < Train

  def initialize(serial)
  	super(serial, Train::Types::CARGO)
  end

  def add_wagon(wagon)
  	return nil if wagon.class != CargoWagon

  	@wagons.push(wagon)
  end
end