def adjacent_cubes(cube)
  [
    [cube[0] + 1, cube[1], cube[2]],
    [cube[0] - 1, cube[1], cube[2]],
    [cube[0], cube[1] + 1, cube[2]],
    [cube[0], cube[1] - 1, cube[2]],
    [cube[0], cube[1], cube[2] + 1],
    [cube[0], cube[1], cube[2] - 1]
  ]
end

def map_pocket(cube, pocket, droplet_cubes)
  # This isn't an interior pocket if it reaches to the outer edge of the droplet.
  return nil if cube[0] <= @min_x || cube[0] >= @max_x || cube[1] <= @min_y || cube[1] >= @max_y || cube[2] <= @min_z || cube[2] >= @max_z

  pocket << cube

  adjacent_cubes(cube).each do |adjacent_cube|
    next if pocket.include?(adjacent_cube)
    next if droplet_cubes.include?(adjacent_cube)

    return nil if map_pocket(adjacent_cube, pocket, droplet_cubes).nil?
  end

  pocket
end

def update_exposed_surface_cubes(cube, cubes, exposed_surface_cubes)
  exposed_surface_cubes << cube unless cubes.include?(cube) || exposed_surface_cubes.include?(cube)
end

cubes = []
File.foreach('input.txt', chomp: true) do |line|
  cubes << line.split(',').map(&:to_i)
end

@min_x = cubes.map { |cube| cube[0] }.min
@max_x = cubes.map { |cube| cube[0] }.max
@min_y = cubes.map { |cube| cube[1] }.min
@max_y = cubes.map { |cube| cube[1] }.max
@min_z = cubes.map { |cube| cube[2] }.min
@max_z = cubes.map { |cube| cube[2] }.max

# Get the set of cubes that are adjacent to any of the droplet cubes.
exposed_surface_cubes = []
cubes.each do |cube|
  adjacent_cubes(cube).each do |adjacent_cube|
    update_exposed_surface_cubes(adjacent_cube, cubes, exposed_surface_cubes)
  end
end

# For each exposed surface cube, explore the area around it to see if it is an
# interior pocket; or if it's on the exterior (or has a connection to the exterior).
exposed_surface_cubes.each do |exposed_surface_cube|
  new_pocket = map_pocket(exposed_surface_cube, [], cubes)

  # If we've identified an interior pocket, just stuff it full of solid cubes,
  # such that it won't be counted when we repeat our surface area calculation
  # from Part 1 (down below).
  cubes += new_pocket unless new_pocket.nil?
end

exposed_surfaces = 0
cubes.each do |cube|
  adjacent_cubes(cube).each do |adjacent_cube|
    exposed_surfaces += 1 unless cubes.include?(adjacent_cube)
  end
end

p exposed_surfaces
