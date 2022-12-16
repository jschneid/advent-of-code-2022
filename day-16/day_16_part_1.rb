class Valve
  attr_reader :id, :flow_rate, :tunnels

  def initialize(id:, flow_rate:, tunnels:)
    @id = id
    @flow_rate = flow_rate
    @tunnels = tunnels
  end
end

def replace_tunnel_valve_ids_with_valve_references(valves)
  valves.each do |valve|
    valve.tunnels.map! { |tunnel| valves.find { |valve| valve.id == tunnel } }
  end
end

def read_data
  valves = []
  File.foreach('input.txt', chomp: true) do |line|
    tokenized_line = line.split
    valves << Valve.new(
      id: tokenized_line[1],
      flow_rate: tokenized_line[4].split('=')[1][..-2].to_i,
      tunnels: tokenized_line[9..].join.split(',')
    )
  end

  replace_tunnel_valve_ids_with_valve_references(valves)

  valves
end

@memoized_travel_times = {}

def travel_time(position, destination_valve, visited_valves)
  return 0 if position == destination_valve

  return @memoized_travel_times[[position, destination_valve]] if @memoized_travel_times.has_key?([position, destination_valve])

  visited_valves << position

  best_travel_time = 999_999

  position.tunnels.each do |neighboring_valve|
    unless visited_valves.include?(neighboring_valve)
      travel_time_from_this_neighbor = travel_time(neighboring_valve, destination_valve, visited_valves.clone)
      best_travel_time = travel_time_from_this_neighbor if travel_time_from_this_neighbor < best_travel_time
    end
  end

  @memoized_travel_times[[position, destination_valve]] = (1 + best_travel_time) if best_travel_time < 999_999

  1 + best_travel_time
end

def solve(position, minutes_left, unopened_valves, pressure_released)
  best_solution = pressure_released

  unopened_valves.each do |next_valve_to_open|
    distance = travel_time(position, next_valve_to_open, [])

    time_to_walk_to_valve_and_open_it = (distance + 1)
    minutes_left_after_open = minutes_left - time_to_walk_to_valve_and_open_it

    if minutes_left_after_open.positive?
      additional_pressure_released = minutes_left_after_open * next_valve_to_open.flow_rate
      updated_unopened_valves = unopened_valves.reject { |valve| valve == next_valve_to_open }
      best_solution_for_this_move = solve(next_valve_to_open, minutes_left_after_open, updated_unopened_valves, pressure_released + additional_pressure_released)

      best_solution = best_solution_for_this_move if best_solution_for_this_move > best_solution
    end
  end

  best_solution
end

valves = read_data
start_position = valves.find { |valve| valve.id == 'AA' }

# At the start, and after opening a value: The optimal next action is going to be
# to walk to a valve D distance away (D minutes) and then open that valve (1 more minute).
#
# So, the moves we need to evaluate are: For each unopened valve (with flow rate > 0),
# spend D+1 turns walking to that valve and opening it.
unopened_valves = valves.filter { |valve| valve.flow_rate.positive? }
p solve(start_position, 30, unopened_valves, 0)

