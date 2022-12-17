class Rock
  attr_reader :points
  attr_accessor :bottom_left_x, :bottom_left_y

  def initialize(points:)
    @points = points
  end

  def grid_points
    result = []
    @points.each do |point|
      result << Point.new(x: bottom_left_x + point.x, y: bottom_left_y + point.y)
    end
    result
  end
end

class Point
  attr_reader :x, :y

  def initialize(x:, y:)
    @x = x
    @y = y
  end
end

def setup_rocks
  rocks = []

  horizontal_line_rock = Rock.new(points: [
    Point.new(x: 0, y: 0),
    Point.new(x: 1, y: 0),
    Point.new(x: 2, y: 0),
    Point.new(x: 3, y: 0)
  ])
  rocks << horizontal_line_rock

  plus_rock = Rock.new(points: [
    Point.new(x: 0, y: 1),
    Point.new(x: 1, y: 0),
    Point.new(x: 1, y: 1),
    Point.new(x: 1, y: 2),
    Point.new(x: 2, y: 1),
  ])
  rocks << plus_rock

  j_rock = Rock.new(points: [
    Point.new(x: 0, y: 0),
    Point.new(x: 1, y: 0),
    Point.new(x: 2, y: 0),
    Point.new(x: 2, y: 1),
    Point.new(x: 2, y: 2)
  ])
  rocks << j_rock

  vertical_line_rock = Rock.new(points: [
    Point.new(x: 0, y: 0),
    Point.new(x: 0, y: 1),
    Point.new(x: 0, y: 2),
    Point.new(x: 0, y: 3)
  ])
  rocks << vertical_line_rock

  square_rock = Rock.new(points: [
    Point.new(x: 0, y: 0),
    Point.new(x: 0, y: 1),
    Point.new(x: 1, y: 0),
    Point.new(x: 1, y: 1)
  ])
  rocks << square_rock

  rocks
end

def tower_height(grid)
  grid.find_index(['.', '.', '.', '.', '.', '.', '.'])
end

def add_rock(rock, grid)
  rock.bottom_left_x = 2
  rock.bottom_left_y = tower_height(grid) + 3
end

def descend_rock_one_step(rock, grid)
  rock.grid_points.each do |point|

    if point.y <= 0 || grid[point.y - 1][point.x] == '#'
      affix_rock(rock, grid)
      return true
    end
  end
  rock.bottom_left_y -= 1
  false
end

def affix_rock(rock, grid)
  rock.grid_points.each do |point|
    grid[point.y][point.x] = '#'
  end
end

def blow_rock_one_step_if_possible(rock, grid, wind)
  dx = wind[@wind_index] == '<' ? -1 : 1
  @wind_index = (@wind_index + 1) % wind.length

  rock.grid_points.each do |point|
    return if point.x + dx < 0 || point.x + dx >= 7 || grid[point.y][point.x + dx] == '#'
  end

  rock.bottom_left_x += dx
end

def drop_rock(rock, grid, wind)
  add_rock(rock, grid)

  loop do
    blow_rock_one_step_if_possible(rock, grid, wind)
    break if descend_rock_one_step(rock, grid)
  end
end

def print_grid(grid)
  y = tower_height(grid) + 6
  while y >= 0
    puts grid[y].join
    y -= 1
  end
end

wind = File.read('input.txt').strip
@wind_index = 0

rocks = setup_rocks
rock_index = 0

grid = []
(13*2022).times do
  grid << ['.', '.', '.', '.', '.', '.', '.']
end

2022.times do
  drop_rock(rocks[rock_index], grid, wind)
  rock_index = (rock_index + 1) % rocks.count
end

print_grid(grid)

p tower_height(grid)
