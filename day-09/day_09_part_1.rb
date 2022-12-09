require 'set'

def move_tail(head, tail)
  delta = { x: (head[:x] - tail[:x]), y: (head[:y] - tail[:y]) }

  return if delta[:x].abs < 2 && delta[:y].abs < 2

  tail[:x] += 1 if delta[:x] > 0
  tail[:x] -= 1 if delta[:x] < 0
  tail[:y] += 1 if delta[:y] > 0
  tail[:y] -= 1 if delta[:y] < 0
end

def perform(instruction, head, tail, tail_positions_visited)
  direction, step_count = instruction.split(' ')
  step_count.to_i.times do
    case direction
    when 'R'
      head[:x] += 1
    when 'L'
      head[:x] -= 1
    when 'U'
      head[:y] += 1
    when 'D'
      head[:y] -= 1
    end
    move_tail(head, tail)
    tail_positions_visited.add(tail.clone)
  end
end

head = { x: 0, y: 0 }
tail = { x: 0, y: 0 }
tail_positions_visited = Set[tail.clone]

File.foreach('input.txt', chomp: true) do |instruction|
  perform(instruction, head, tail, tail_positions_visited)
end

p tail_positions_visited.count
