require_relative 'Train'
require_relative 'PassengerWagon'

class PassengerTrain < Train

  def initialize(serial)
  	super(serial, Train::Types::PASSENGER)
  end

  def add_wagon(wagon)
  	return nil if wagon.class != PassengerWagon

  	@wagons.push(wagon)
  end
end