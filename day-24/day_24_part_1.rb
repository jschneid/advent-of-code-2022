require 'set'

class Point
  attr_accessor :x, :y

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def ==(other)
    eql?(other)
  end

  def eql?(other)
    @x == other.x && @y == other.y
  end

  def hash
    @x * 6113 + y
  end

  def to_s
    "x=#{@x} y=#{@y}"
  end
end

class Blizzard
  attr_accessor :location, :step

  def initialize(x, y, char)
    @location = Point.new(x: x, y: y)

    case char
    when '<'
      @step = { x: -1, y: 0 }
    when '>'
      @step = { x: 1, y: 0 }
    when '^'
      @step = { x: 0, y: -1 }
    when 'v'
      @step = { x: 0, y: 1 }
    end
  end

  def x
    @location.x
  end

  def y
    @location.y
  end

  def advance(field_width, field_height)
    @location.x += @step[:x]
    @location.y += @step[:y]
    wrap(field_width, field_height)
  end

  def wrap(field_width, field_height)
    if @location.y < 0
      @location.y = field_height - 1
    elsif y >= field_height
      @location.y = 0
    elsif @location.x < 0
      @location.x = field_width - 1
    elsif @location.x >= field_width
      @location.x = 0
    end
  end
end

def read_map
  blizzards = []
  blizzard_chars = ['>', 'v', '<', '^']
  map = File.readlines('input.txt', chomp: true)
  field_width = map[0].length - 2
  field_height = map.length - 2
  map[1..-2].each_with_index do |line, y|
    line[1..-2].chars.each_with_index do |char, x|
      blizzards << Blizzard.new(x, y, char) if blizzard_chars.include?(char)
    end
  end
  [blizzards, field_width, field_height]
end

def precompute_map_states(blizzards)
  map_states = []
  @field_width.lcm(@field_height).times do
    positions = Set.new
    blizzards.each { |blizzard| positions << blizzard.location.clone }
    map_states << positions
    blizzards.each { |blizzard| blizzard.advance(@field_width, @field_height) }
  end
  map_states
end

def solve(possible_expedition_positions, map_states, steps)
  loop do
    return steps + 1 if possible_expedition_positions.include?(@exit)

    steps += 1
    next_map_state = map_states[steps % map_states.count]
    possible_expedition_positions = get_next_possible_positions(possible_expedition_positions, next_map_state)
  end
end

def get_next_possible_positions(possible_expedition_positions, next_map_state)
  next_possible_positions = Set.new

  possible_expedition_positions.each do |position|
    get_possible_next_positions(position, next_map_state).each do |next_position|
      next_possible_positions << next_position
    end
  end

  next_possible_positions
end

def get_possible_next_positions(position, map_state)
  possible_next_positions = []

  if position.x < @field_width - 1 && position.y >= 0
    east = Point.new(x: position.x + 1, y: position.y)
    possible_next_positions << east unless map_state.include?(east)
  end

  if position.y < @field_height - 1
    south = Point.new(x: position.x, y: position.y + 1)
    possible_next_positions << south unless map_state.include?(south)
  end

  if position.x > 0
    west = Point.new(x: position.x - 1, y: position.y)
    possible_next_positions << west unless map_state.include?(west)
  end

  if position.y > 0
    north = Point.new(x: position.x, y: position.y - 1)
    possible_next_positions << north unless map_state.include?(north)
  end

  possible_next_positions << position unless map_state.include?(position)

  possible_next_positions
end

blizzards, @field_width, @field_height = read_map

map_states = precompute_map_states(blizzards)

@exit = Point.new(x: @field_width - 1, y: @field_height - 1)

p solve(Set[Point.new(x: 0, y: -1)], map_states, 0)
