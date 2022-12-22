class Go
  attr_reader :steps

  def initialize(steps)
    @steps = steps
    @map_width = nil
    @map_height = nil
  end

  def perform(map, x, y, facing)
    @steps.times do
      next_x, next_y = next_position(map, x, y, facing)

      break if map[next_y][next_x] == '#'

      next_x, next_y = wrap(map, x, y, facing) if map[next_y][next_x] != '.'

      break if map[next_y][next_x] == '#'

      x = next_x
      y = next_y
    end

    [x, y, facing]
  end

  def wrap(map, x, y, facing)
    case facing
    when 0
      x = map[y].chars.find_index { |c| c == '.' || c == '#' }
    when 1
      y = map.map { |line| line[x] }.find_index { |c| c == '.' || c == '#' }
    when 2
      x = map[y].chars.rindex { |c| c == '.' || c == '#' }
    when 3
      y = map.map { |line| line[x] }.rindex { |c| c == '.' || c == '#' }
    end

    [x, y]
  end

  def map_width(map)
    @map_width || map.map(&:length).max
  end

  def map_height(map)
    @map_height || map.length
  end

  def next_position(map, x, y, facing)
    next_x = x
    next_y = y
    case facing
    when 0
      next_x += 1
    when 1
      next_y += 1
    when 2
      next_x -= 1
    when 3
      next_y -= 1
    end
    next_x = next_x % map_width(map)
    next_y = next_y % map_height(map)

    [next_x, next_y]
  end
end

class Turn
  attr_reader :turn

  def initialize(turn)
    @turn = turn
  end

  def perform(map, x, y, facing)
    facing += 1 if @turn == 'R'
    facing -= 1 if @turn == 'L'
    facing = facing % 4

    [x, y, facing]
  end
end

def parse_moves(move_data)
  moves = []
  i = 0
  while i < move_data.length
    j = i
    j += 1 while move_data[j] != nil && move_data[j].ord <= 57
    moves << Go.new(move_data[i..(j - 1)].to_i)

    moves << Turn.new(move_data[j]) unless move_data[j].nil?
    i = j + 1
  end

  moves
end

def perform_moves(moves, map)
  y = 0
  x = map.first.chars.find_index { |c| c == '.' }
  facing = 0

  p "Starting at x #{x} y #{y}"

  moves.each do |move|
    x, y, facing = move.perform(map, x, y, facing)
  end

  [x, y, facing]
end

def final_password(x, y, facing)
  (y + 1) * 1000 + (x + 1) * 4 + facing
end

data = File.readlines('input.txt', chomp: true)
moves = parse_moves(data.pop)

map = data.reject(&:empty?)

x, y, facing = perform_moves(moves, map)

p "ended at x #{x} y #{y} facing #{facing}"
p final_password(x, y, facing)
