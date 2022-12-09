require 'set'

def move_trailing_knot(base_knot, trailing_knot)
  delta = { x: (base_knot[:x] - trailing_knot[:x]), y: (base_knot[:y] - trailing_knot[:y]) }

  return if delta[:x].abs < 2 && delta[:y].abs < 2

  trailing_knot[:x] += 1 if delta[:x] > 0
  trailing_knot[:x] -= 1 if delta[:x] < 0
  trailing_knot[:y] += 1 if delta[:y] > 0
  trailing_knot[:y] -= 1 if delta[:y] < 0
end

def perform(instruction, knots, tail_positions_visited)
  direction, step_count = instruction.split(' ')
  step_count.to_i.times do
    case direction
    when 'R'
      knots.first[:x] += 1
    when 'L'
      knots.first[:x] -= 1
    when 'U'
      knots.first[:y] += 1
    when 'D'
      knots.first[:y] -= 1
    end

    (1..(knots.count - 1)).each do |knot_index|
      move_trailing_knot(knots[knot_index - 1], knots[knot_index])
    end

    tail_positions_visited.add(knots.last.clone)
  end
end

knots = []
10.times do
  knots << { x: 0, y: 0 }
end
tail_positions_visited = Set[knots.last.clone]

File.foreach('input.txt', chomp: true) do |instruction|
  perform(instruction, knots, tail_positions_visited)
end

p tail_positions_visited.count
