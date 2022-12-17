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

def add_rock(rock, grid)
  rock.bottom_left_x = 2
  rock.bottom_left_y = @tower_height + 3
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
    @tower_height = point.y+1 if @tower_height < point.y+1
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

wind = File.read('input.txt').strip
@wind_index = 0

rocks = setup_rocks
rock_index = 0

grid = []
700_000.times do
  grid << ['.', '.', '.', '.', '.', '.', '.']
end

@tower_height = 0

# For my AoC input the top level of the tower becomes "#######" in a pattern!
# Per the below code:
# - Every 2060 rocks dropped, starting with #486 (so 486, 2546, 4606, ...)
# - Height is at 792 at height 486, then increases by 3044 on each repeat of the pattern.
# - The next rock index and wind index after the pattern are 1 (not 0) and 2870 respectively.
drop_count  = 0
100_000.times do
  drop_rock(rocks[rock_index], grid, wind)
  drop_count += 1
  rock_index = (rock_index + 1) % rocks.count
  p "#{drop_count},#{@tower_height} next rock index #{rock_index} next wind index #{@wind_index}" if grid[@tower_height - 1] == ['#', '#', '#', '#', '#', '#', '#']
end

# Armed with the above information, I did some math:
# - The closest # of rocks in the repeating pattern to our target of 1000000000000
#   without going over is 999999999316.
# - That many rocks gives 1565517240324 in height.
#   - The first 486 rocks give 792 height.
#   - Then a total of 1565517240324 height from adding the remaining rocks.
# - Running the part 1 code for the remaining 684 rocks, and initializing the
#   rock and wind indicies as above, resulted in another 1058 height.
# - The combined total of those 2 height values was the correct solution!
