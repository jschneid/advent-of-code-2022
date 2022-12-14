# My input is shaped like:
#
#  ab
#  c
# de
# f
#
# So... I actually did a 2:00am arts and crafts project, and made that cube on
# actual paper and folded it! Check it out!
#
# https://jonschneider.com/images/jsblog/AdventOfCodeDay22Part2.jpg
#
# It yields mappings (new facings):
#
# a:
# - right: b (right)
# - down: c (down)
# - left: d (right)
# - up: f (right)
#
# b:
# - right: e (left)
# - down: c (left)
# - left: a (left)
# - up: f (up)
#
# c:
# - right: b (up)
# - down: e (down)
# - left: d (down)
# - up: a (up)
#
# d:
# - right: e (right)
# - down: f (down)
# - left: a (right)
# - up: c (right)
#
# e:
# - right: b (left)
# - down: f (left)
# - left: d (left)
# - up: c (up)
#
# f:
# - right: e (up)
# - down: b (down)
# - left: a (down)
# - up: d (up)
#
# (The specific code below won't work with inputs that are in a different
# unfolded shape! The "get_face" and "wrap" functions would need to be
# adapted for the new shape. Alternatively, I could come up with logic
# that could dynamically come up with the math required, given any possible
# input... but I'm not taking that on at this time!)

class Go
  attr_reader :steps

  def initialize(steps)
    @steps = steps
    @map_width = nil
    @map_height = nil
  end

  def perform(map, x, y, facing)
    @steps.times do
      next_x, next_y = next_position(x, y, facing)
      next_facing = facing

      break if map[next_y] != nil && map[next_y][next_x] == '#'

      if next_x < 0 || next_y < 0 || map[next_y].nil? || map[next_y][next_x] != '.'
        next_x, next_y, next_facing = wrap(x, y, facing)
      end

      break if map[next_y][next_x] == '#'

      x = next_x
      y = next_y
      facing = next_facing
    end

    [x, y, facing]
  end

  def get_face(x, y)
    if y >= 0 && y < 50 && x >= 100 && x < 150
      :b
    elsif y >= 0 && y < 50 && x >= 50 && x < 100
      :a
    elsif y >= 50 && y < 100 && x >= 50 && x < 100
      :c
    elsif y >= 100 && y < 150 && x >= 50 && x < 100
      :e
    elsif y >= 100 && y < 150 && x >= 0 && x < 50
      :d
    elsif y >= 150 && y < 200 && x >= 0 && x < 50
      :f
    else
      raise "Error: Invalid face for y=#{y} x=#{x}"
    end
  end

  def wrap(x, y, facing)
    next_x = x
    next_y = y
    next_facing = facing

    face = get_face(x, y)

    case facing
    when 0
      case face
      when :a
        next_x = x + 1
      when :b
        next_facing = 2
        next_x = 99
        next_y = 149 - y
      when :c
        next_facing = 3
        next_x = y + 50
        next_y = 49
      when :d
        next_x = x + 1
      when :e
        next_facing = 2
        next_x = 149
        next_y = 149 - y
      when :f
        next_facing = 3
        next_x = y - 100
        next_y = 149
      end
    when 1
      case face
      when :a
        next_y = y + 1
      when :b
        next_facing = 2
        next_x = 99
        next_y = x - 50
      when :c
        next_y = y + 1
      when :d
        next_y = y + 1
      when :e
        next_facing = 2
        next_x = 49
        next_y = x + 100
      when :f
        next_x = x + 100
        next_y = 0
      end
    when 2
      case face
      when :a
        next_facing = 0
        next_x = 0
        next_y = 149 - y
      when :b
        next_x = x - 1
      when :c
        next_facing = 1
        next_x = y - 50
        next_y = 100
      when :d
        next_facing = 0
        next_x = 50
        next_y = 149 - y
      when :e
        next_x = x - 1
      when :f
        next_facing = 1
        next_x = y - 100
        next_y = 0
      end
    when 3
      case face
      when :a
        next_facing = 0
        next_x = 0
        next_y = x + 100
      when :b
        next_x = x - 100
        next_y = 199
      when :c
        next_y = 49
      when :d
        next_facing = 0
        next_x = 50
        next_y = x + 50
      when :e
        next_y = 99
      when :f
        next_y = 149
      end
    else
      raise "Error: Unknown facing #{facing}"
    end

    [next_x, next_y, next_facing]
  end

  def next_position(x, y, facing)
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

p "Ended at x #{x} y #{y}, facing #{facing}"
p "Final password: #{final_password(x, y, facing)}"
