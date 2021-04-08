# frozen_string_literal: true

require_relative 'PassengerTrain'
require_relative 'CargoTrain'
require_relative 'PassengerWagon'
require_relative 'CargoWagon'
require_relative 'Route'
require_relative 'Station'

$stations = {}
$routes = {}
$trains = {}

def create_station(name)
  $stations[name] = Station.new(name)
end

def create_train(serial, str_type)
  current_type = (str_type == 'p' ? Train::Types::PASSENGER : Train::Types::CARGO)

  $trains[serial] = Train.new(serial, current_type)
end

def create_route(name, first, last)
  $routes[name] = Route.new($stations[first], $stations[last])
end

def add_station_to_route(station_name, route_name)
  $routes[route_name].add_station($stations[station_name])
end

def remove_station_from_route(station_name, route_name)
  $routes[route_name].delete_station($stations[station_name])
end

def set_train_route(train_serial, route_name)
  $trains[train_serial].route = $routes[route_name]
end

def add_wagon(train_serial)
  $trains[train_serial].add_wagon(PassengerWagon.new)
end

def remove_wagon(train_serial, index)
  $trains[train_serial].remove_wagon(index)
end

# if go back then forward = false
def train_go(train_serial, direction)
  forward = (direction == 'forward')

  if forward
    $trains[train_serial].go_next
  else
    $trains[train_serial].go_back
  end
end

def print_station_list
  puts 'stations:'
  $stations.each_key { |station_name| print("#{station_name} ") }
  puts
end

def print_trains_list
  puts 'trains:'
  $trains.each_key { |train_serial| print("#{train_serial} ") }
  puts
end

def print_routes_list
  puts 'routes:'
  $routes.each_key { |route_name| print("#{route_name} ") }
  puts
end

def print_station_trains(station_name, str_type = nil)
  puts "trains on station #{station_name}:"
  current_type = (str_type == 'p' ? Train::Types::PASSENGER : Train::Types::CARGO)
  $trains = $stations[station_name].trains(current_type)

  $trains.each { |train| print("#{train.serial} ") }
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
  puts '3 - to go to Route commands list:'
  puts '    create [route_name] [first_station] [last_station]- to create route with name [route_name],'
  puts '      first station at [first_station] and last station at [last_station]'
  puts '    print - to print routes list'
  puts '    add [route_name] [station_name] - to add station with name [station_name] to route [route_name]'
  puts '    rm [route_name] [station_name] - to remove station with name [station_name] from route [route_name]'
  puts '    back - to go back'
  puts 'exit - to exit'
end

help

menu_number = 0

loop do
  begin
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
      case menu_number
      when 1
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
            throw ''

          end

        else
          throw ''

        end

      when 2
        case input[0]
        when 'create'
          create_train(input[1], input[2])

        when 'print'
          print_trains_list

        when 'set'
          set_train_route(input[1], input[2])

        when 'go'
          train_go(input[1], input[2])

        else
          throw ''

        end

      when 3
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
          throw ''

        end

      else
        throw ''

      end
    end
  rescue StandardError
    puts 'oops something went wrong. Try again'
  end
end
