def visible_from_direction(grid, y, x, dy, dx)
  initial_tree_height = grid[y][x]
  while y > 0 && x > 0 && y < (grid.size - 1) && x < (grid[0].size - 1)
    return false if initial_tree_height <= grid[y + dy][x + dx]

    y += dy
    x += dx
  end
  true
end

def visible_from_north(grid, y, x)
  visible_from_direction(grid, y, x, -1, 0)
end

def visible_from_south(grid, y, x)
  visible_from_direction(grid, y, x, 1, 0)
end

def visible_from_west(grid, y, x)
  visible_from_direction(grid, y, x, 0, -1)
end

def visible_from_east(grid, y, x)
  visible_from_direction(grid, y, x, 0, 1)
end

def visible_from_any_direction(grid, y, x)
  visible_from_north(grid, y, x) || visible_from_south(grid, y, x) || visible_from_west(grid, y, x) || visible_from_east(grid, y, x)
end

grid = []
File.foreach('input.txt', chomp: true) do |line|
  grid << line.split('').map(&:to_i)
end

visible_trees = 0

grid.each_index do |y|
  grid[y].each_index do |x|
    visible_trees += 1 if visible_from_any_direction(grid, y, x)
  end
end

p visible_trees
