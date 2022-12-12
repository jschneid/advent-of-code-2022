def read_map
  heightmap = []
  start_position = nil

  File.readlines('input.txt', chomp: true).each_with_index do |line, index|
    heightmap << line

    start_position_index = line.index('S')
    start_position = { y: index, x: start_position_index } unless start_position_index.nil?
  end

  [heightmap, start_position]
end

def height_at(heightmap, position)
  return 'a'.ord if heightmap[position[:y]][position[:x]] == 'S'
  return 'z'.ord if heightmap[position[:y]][position[:x]] == 'E'

  heightmap[position[:y]][position[:x]].ord
end

def find_shortest_path(heightmap, current_position, visited_positions, moves)
  return nil if visited_positions[current_position] != nil && visited_positions[current_position] <= moves

  visited_positions[current_position] = moves

  return moves if heightmap[current_position[:y]][current_position[:x]] == 'E'

  moves += 1

  possible_next_positions = [
    { y: (current_position[:y] - 1), x: (current_position[:x]) },
    { y: (current_position[:y] + 1), x: (current_position[:x]) },
    { y: (current_position[:y]), x: (current_position[:x] - 1) },
    { y: (current_position[:y]), x: (current_position[:x] + 1) }
  ]

  minimum_distance_to_end = Float::INFINITY
  possible_next_positions.each do |next_position|
    y = next_position[:y]
    x = next_position[:x]
    next if x < 0 || y < 0 || y >= heightmap.size || x >= heightmap[0].size
    next if (height_at(heightmap, next_position) - height_at(heightmap, current_position)) >= 2

    distance_to_end = find_shortest_path(heightmap, next_position, visited_positions, moves)

    minimum_distance_to_end = distance_to_end if !distance_to_end.nil? && distance_to_end < minimum_distance_to_end
  end

  minimum_distance_to_end
end

heightmap, start_position = read_map

p find_shortest_path(heightmap, start_position, {}, 0)
