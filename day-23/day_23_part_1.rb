require 'set'

class Point
  attr_accessor :x, :y

  def initialize(x, y)
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
end

class Elf
  attr_accessor :location, :proposed_location

  def initialize(x, y)
    @location = Point.new(x, y)
  end

  def x
    @location.x
  end

  def y
    @location.y
  end

  def set_proposed_location(elf_positions, direction_order)
    @proposed_location = nil
    if no_other_elves_adjacent?(elf_positions)
      # noop
    else
      direction_order.each do |direction|
        break if set_proposed_location_for_direction(elf_positions, direction)
      end
    end
  end

  def no_other_elves_adjacent?(elf_positions)
    return false if elf_positions.include?(Point.new(x - 1, y - 1))
    return false if elf_positions.include?(Point.new(x, y - 1))
    return false if elf_positions.include?(Point.new(x + 1, y - 1))
    return false if elf_positions.include?(Point.new(x - 1, y))
    return false if elf_positions.include?(Point.new(x + 1, y))
    return false if elf_positions.include?(Point.new(x - 1, y + 1))
    return false if elf_positions.include?(Point.new(x, y + 1))
    return false if elf_positions.include?(Point.new(x + 1, y + 1))
    true
  end

  def set_proposed_location_for_direction(elf_positions, direction)
    case direction
    when :N
      return false if elf_positions.include?(Point.new(x - 1, y - 1))
      return false if elf_positions.include?(Point.new(x, y - 1))
      return false if elf_positions.include?(Point.new(x + 1, y - 1))
      @proposed_location = Point.new(x, y - 1)
      return true
    when :S
      return false if elf_positions.include?(Point.new(x - 1, y + 1))
      return false if elf_positions.include?(Point.new(x, y + 1))
      return false if elf_positions.include?(Point.new(x + 1, y + 1))
      @proposed_location = Point.new(x, y + 1)
      return true
    when :W
      return false if elf_positions.include?(Point.new(x - 1, y - 1))
      return false if elf_positions.include?(Point.new(x - 1, y))
      return false if elf_positions.include?(Point.new(x - 1, y + 1))
      @proposed_location = Point.new(x - 1, y)
      return true
    when :E
      return false if elf_positions.include?(Point.new(x + 1, y - 1))
      return false if elf_positions.include?(Point.new(x + 1, y))
      return false if elf_positions.include?(Point.new(x + 1, y + 1))
      @proposed_location = Point.new(x + 1, y)
      return true
    end
    false
  end
end

def do_round_first_half(elves, direction_order)
  elf_positions = elves.map(&:location).to_set

  elves.each do |elf|
    elf.set_proposed_location(elf_positions, direction_order)
  end
end

def do_round_second_half(elves)
  proposed_locations_tally = elves.map(&:proposed_location).reject(&:nil?).tally

  elves.each do |elf|
    elf.location = elf.proposed_location unless elf.proposed_location.nil? || proposed_locations_tally[elf.proposed_location] > 1
  end
end

def do_round(elves, direction_order)
  do_round_first_half(elves, direction_order)

  do_round_second_half(elves)

  direction_order.rotate!(1)
end

def read_elves
  elves = []
  File.readlines('input.txt', chomp: true).each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      elves << Elf.new(x, y) if char == '#'
    end
  end
  elves
end

def empty_ground_tiles(elves)
  elf_locations = elves.map(&:location)
  elf_x_values = elf_locations.map(&:x)
  elf_y_values = elf_locations.map(&:y)

  (elf_y_values.max - elf_y_values.min + 1) * (elf_x_values.max - elf_x_values.min + 1) - elves.count
end

elves = read_elves

direction_order = [:N, :S, :W, :E]
10.times do
  do_round(elves, direction_order)
end

p empty_ground_tiles(elves)
