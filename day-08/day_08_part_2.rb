def trees_visible_to_direction(grid, y, x, dy, dx)
  initial_tree_height = grid[y][x]
  visible_trees = 0

  y += dy
  x += dx

  while y >= 0 && x >= 0 && y < grid.size && x < grid[0].size
    visible_trees += 1

    break if initial_tree_height <= grid[y][x]

    y += dy
    x += dx
  end

  visible_trees
end

def trees_visible_to_north(grid, y, x)
  trees_visible_to_direction(grid, y, x, -1, 0)
end

def trees_visible_to_south(grid, y, x)
  trees_visible_to_direction(grid, y, x, 1, 0)
end

def trees_visible_to_west(grid, y, x)
  trees_visible_to_direction(grid, y, x, 0, -1)
end

def trees_visible_to_east(grid, y, x)
  trees_visible_to_direction(grid, y, x, 0, 1)
end

def scenic_score(grid, y, x)
  trees_visible_to_north(grid, y, x) * trees_visible_to_south(grid, y, x) * trees_visible_to_west(grid, y, x) * trees_visible_to_east(grid, y, x)
end

grid = []
File.foreach('input.txt', chomp: true) do |line|
  grid << line.split('').map(&:to_i)
end

max_scenic_score = 0

grid.each_index do |y|
  grid[y].each_index do |x|
    current_scenic_score = scenic_score(grid, y, x)
    max_scenic_score = current_scenic_score if max_scenic_score < current_scenic_score
  end
end

p max_scenic_score
