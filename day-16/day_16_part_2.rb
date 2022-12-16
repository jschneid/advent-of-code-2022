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

unopened_valves = valves.filter { |valve| valve.flow_rate.positive? }

# Let's assume that the portion of the flow_rate > 0 valves that I will open
# (with the elephant being responsible for the remainder) will be ABOUT
# half of the total count available.
#
# Get an array with all of the possible sets of flow_rate > 0 valves that
# could be my responsibility to open. (My AoC input had 16 such valves; so
# get an array with all combinations of 8, 7, and 6 out of those 16 valves.)
# Happily, Ruby provides a method, Array.combination, that does this for us!
# https://apidock.com/ruby/v2_5_5/Array/combination
half_count = unopened_valves.count / 2
my_combinations_to_try = unopened_valves.combination(half_count) + unopened_valves.combination(half_count - 1) + unopened_valves.combination(half_count - 2)

# Now, we just need to run the "Part 1" solver for a bunch of different
# pairs of sets of flow_rate > 0 valves: I take a portion, the elephant takes
# the remainder, and we add up the two results. Then we just take the best
# overall total result.
best_pressure_released = 0
my_combinations_to_try.each do |my_combination|
  elephant_combination = unopened_valves - my_combination
  pressure_released = solve(start_position, 26, my_combination, 0)
  pressure_released += solve(start_position, 26, elephant_combination, 0)

  best_pressure_released = pressure_released if pressure_released > best_pressure_released
end

p best_pressure_released

