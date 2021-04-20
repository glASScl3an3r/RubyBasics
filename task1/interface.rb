# frozen_string_literal: true

require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'route'
require_relative 'station'

class Interface
  def initialize
    @stations = {}
    @routes   = {}
    @trains   = {}
  end

  def start
    menu_number = 0
    help

    loop do
      begin
        # create train1 p -> ['create', 'train1', 'p'] - create train with name train1 and passenger type
        input = gets.chomp.split(' ')

        case input[0]
        when 'exit'
          puts 'good bye!'
          break
        when 'h'
          help
          puts
        when '1'
          puts 'stations menu. Type your commands'
          menu_number = 1
        when '2'
          puts 'trains menu. Type your commands'
          menu_number = 2
        when '3'
          puts 'routes menu. Type your commands'
          menu_number = 3
        when 'back'
          puts 'choose menu: 1(stations) 2(trains) 3(routes)'
          menu_number = 0
        else
          menu_actions(input, menu_number)
        end
      rescue StandardError => e
        print e.inspect
        puts 'repeat your command with correct args'
      end
    end
  end

  # interface only provides a start method, others used for simplify the code
  private

  def menu_actions(input, current_menu)
    case current_menu
    when 1
      station_actions(input)
    when 2
      train_actions(input)
    when 3
      route_actions(input)
    else
      invalid
    end
  end

  def station_actions(input)
    case input[0]
    when 'create'
      create_station(input[1])
    when 'print'
      case input.length
      when 1
        print_station_list
      when 2
        print_station_trains(input[1])
      when 3
        print_station_trains(input[1], input[2])
      else
        invalid
      end
    else
      invalid
    end
  end

  def train_actions(input)
    case input[0]
    when 'create'
      create_train(input[1], input[2])
    when 'print'
      case input.length
      when 1
        print_trains_list
      when 2
        print_train(input[1])
      else
        invalid
      end
    when 'set'
      set_train_route(input[1], input[2])
    when 'go'
      train_go(input[1], input[2])
    when 'add'
      add_wagon(input[1], input[2].to_i)
    when 'rm'
      add_wagon(input[1], input[2].to_i)
    when 'takeseat'
      take_seat(input[1], input[2].to_i)
    when 'takevolume'
      take_volume(input[1], input[2].to_i, input[3].to_f)
    else
      invalid
    end
  end

  def route_actions(input)
    case input[0]
    when 'create'
      create_route(input[1], input[2], input[3])
    when 'print'
      print_routes_list
    when 'add'
      add_station_to_route(input[1], input[2])
    when 'rm'
      remove_station_from_route(input[1], input[2])
    else
      invalid
    end
  end

  def invalid
    puts 'invalid command, try again'
  end

  def create_station(station_name)
    @stations[station_name] = Station.new(station_name)
    puts "station with name #{station_name} created"
  end

  def create_train(train_serial, str_type)
    @trains[train_serial] = if str_type == 'p'
                              PassengerTrain.new(train_serial)
                            else
                              CargoTrain.new(train_serial)
                            end
    puts "train with serial #{train_serial} and #{@trains[train_serial].type} type created"
  end

  def create_route(route_name, first, last)
    @routes[route_name] = Route.new(@stations[first], @stations[last])
    puts "route with name #{route_name} created"
  end

  def add_station_to_route(route_name, station_name)
    @routes[route_name].add_station(@stations[station_name])
  end

  def remove_station_from_route(station_name, route_name)
    @routes[route_name].delete_station(@stations[station_name])
  end

  def set_train_route(train_serial, route_name)
    @trains[train_serial].route = @routes[route_name]
  end

  def add_wagon(train_serial, count)
    cur_train = @trains[train_serial]

    (1..count).each do |i|
      puts "wagon #{i}: " + ((cur_train.type == :passenger)? "type seats count:" : "type max volume")
      input = gets.chomp
      new_wagon = ((cur_train.type == :passenger)? PassengerWagon.new(input.to_i) : CargoWagon.new(input.to_f))
      cur_train.add_wagon(new_wagon)
    end
  end

  def remove_wagon(train_serial, count)
    # remove count wagons from train back
    (1..count).each { |i| @trains[train_serial].remove_wagon(@trains[train_serial].wagons.count - i); }
    puts "removed #{count} wagons from train #{train_serial}"
  end

  def train_go(train_serial, direction)
    if direction == 'forward'
      @trains[train_serial].go_next
      puts "train #{train_serial} passed ahead"
    else
      @trains[train_serial].go_back
      puts "train #{train_serial} passed back"
    end
  end

  def print_station_list
    puts 'stations:'
    puts 'no stations here' if @stations.empty?
    @stations.each_key { |station_name| print("#{station_name} ") }
    puts
  end

  def print_trains_list
    puts 'trains:'
    puts 'no trains here' if @trains.empty?
    @trains.each_key { |train_serial| print("#{train_serial} ") }
    puts
  end

  def print_train(serial)
    cur_train = Train.find(serial)
    if cur_train.nil?
      puts "No train with serial #{serial}"
    else
      puts "Train #{cur_train.serial} : type - #{cur_train.type}, "\
           "producer - #{cur_train.producer || "unknown"}, speed - #{cur_train.speed}, wagons:"

      if cur_train.wagons.count.zero?
        puts 'this train is empty'
      else
        puts "this train contains #{cur_train.wagons.count} wagons:"
        cur_wagon = 0
        cur_train.foreach_wagon do |wagon|
          if wagon.type == :cargo
            puts "wagon #{cur_wagon += 1}: free - #{wagon.free_volume} m^3, used - #{wagon.occupied_volume} m^3"
          elsif wagon.type == :passenger
            puts "wagon #{cur_wagon += 1}: free - #{wagon.free_seats} seats, busy - #{wagon.busy_seats} seats"
          end
        end
      end
    end
  end

  def print_routes_list
    puts 'routes:'
    @routes.each_key { |route_name| print("#{route_name} ") }
    puts
  end

  def print_station_trains(station_name, str_type = nil)
    puts "trains on station #{station_name}:"
    current_type = nil
    current_type = :passenger if str_type == 'p'
    current_type = :cargo if str_type == 'c'

    @stations[station_name].foreach_train(current_type) do |train|
      puts "train #{train.serial} with #{train.wagons.count} wagons"
    end

    puts
  end

  def take_seat(serial, index)
    cur_train = @trains[serial]
    if cur_train.type != :passenger
      puts "cant take a seat in non passenger train"
    else
      cur_train.wagons[index].take_seat
      puts "done"
    end
  end

  def take_volume(serial, index, volume)
    cur_train = @trains[serial]
    if cur_train.type != :cargo
      puts "cant take a volume in non cargo train"
    else
      cur_train.wagons[index].take_volume(volume)
      puts "done"
    end
  end

  def help
    puts 'type h to print this commands list'
    puts 'type:'
    puts '1 - to go to Station commands list:'
    puts '    create [name] - to create station with name [name]'
    puts '    print - to print all stations names'
    puts '    print [station_name] - to print trains on station [station_name]'
    puts "    print [station_name] [type] - to print trains on station [station_name] with type [type]('p'/'c'). "
    puts '    back - to go back'
    puts '2 - to go to Train commands list:'
    puts "    create [train_serial] [type] - to create train with serial [train_serial] and type 'p'/'c' (passenger or cargo)"
    puts '    print - to print all trains serials'
    puts '    print [serial] - to print info about train with serial [serial]'
    puts '    set [serial] [route_name] - to set route with name [route_name] to train with serial [serial]'
    puts "    go [train_serial] [direction] - to move train with serial [train_serial] 'forward'/'back'"
    puts '    add [serial] [count]- to add [count] wagons to train [serial]'
    puts '    rm [serial] [count]- to remove [count] wagons from train [serial]'
    puts '    takeseat [serial] [index] - to take a seat in [index] wagon in train [serial]'
    puts '    takevolume [serial] [index] [volume] - to take a volume in [index] wagon in train [serial]'
    puts '    back - to go back'
    puts '3 - to go to Route commands list:'
    puts '    create [route_name] [first_station] [last_station]- to create route with name [route_name],'
    puts '      first station at [first_station] and last station at [last_station]'
    puts '    print - to print routes list'
    puts '    add [route_name] [station_name] - to add station with name [station_name] to route [route_name]'
    puts '    rm [route_name] [station_name] - to remove station with name [station_name] from route [route_name]'
    puts '    back - to go back'
    puts 'exit - to exit'
  end
end
