cubes = []
File.foreach('input.txt', chomp: true) do |line|
  cubes << line.split(',').map(&:to_i)
end

exposed_surfaces = 0
cubes.each do |cube|
  exposed_surfaces += 1 unless cubes.include?([cube[0] + 1, cube[1], cube[2]])
  exposed_surfaces += 1 unless cubes.include?([cube[0] - 1, cube[1], cube[2]])
  exposed_surfaces += 1 unless cubes.include?([cube[0], cube[1] + 1, cube[2]])
  exposed_surfaces += 1 unless cubes.include?([cube[0], cube[1] - 1, cube[2]])
  exposed_surfaces += 1 unless cubes.include?([cube[0], cube[1], cube[2] + 1])
  exposed_surfaces += 1 unless cubes.include?([cube[0], cube[1], cube[2] - 1])
end

p exposed_surfaces
