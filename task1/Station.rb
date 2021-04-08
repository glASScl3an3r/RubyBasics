class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains.push(train)
  end

  def delete_train(train)
    @trains.delete(train)
  end

  def trains(type = nil)
    return @trains if type.nil?

    trains_to_return = []

    @trains.each do |train|
      trains_to_return.push(train) if train.type == type
    end

    trains_to_return
  end

  def send_train
    current_train = @trains[0]
    @trains.shift
    current_train.go_next
  end
end