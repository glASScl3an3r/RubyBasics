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
      print_trains_list
    when 'set'
      set_train_route(input[1], input[2])
    when 'go'
      train_go(input[1], input[2])
    when 'add'
      add_wagon(input[1], input[2].to_i)
    when 'rm'
      add_wagon(input[1], input[2].to_i)
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
  end

  def create_train(train_serial, str_type)
    @trains[train_serial] = if str_type == 'p'
                              PassengerTrain.new(train_serial)
                            else
                              CargoTrain.new(train_serial)
                            end
  end

  def create_route(route_name, first, last)
    @routes[route_name] = Route.new(@stations[first], @stations[last])
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
    (1..count).each { |_i| @trains[train_serial].add_wagon(PassengerWagon.new); }
  end

  def remove_wagon(train_serial, count)
    #remove count wagons from train back
    (1..count).each { |i| @trains[train_serial].remove_wagon(@trains[train_serial].wagons.count - i); }
  end

  def train_go(train_serial, direction)
    if direction == 'forward'
      @trains[train_serial].go_next
    else
      @trains[train_serial].go_back
    end
  end

  def print_station_list
    puts 'stations:'
    @stations.each_key { |station_name| print("#{station_name} ") }
    puts
  end

  def print_trains_list
    puts 'trains:'
    @trains.each_key { |train_serial| print("#{train_serial} ") }
    puts
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

    @trains = @stations[station_name].trains(current_type)

    @trains.each { |train| print("#{train.serial} ") }
    puts
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
    puts '    set [train_serial] [route_name] - to set route with name [route_name] to train with serial [train_serial]'
    puts "    go [train_serial] [direction] - to move train with serial [train_serial] 'forward'/'back'"
    puts '    back - to go back'
    puts '    add [count[- to add [count] wagons'
    puts '    rm [count]- to remove [count] wagons'
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
