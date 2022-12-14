def init_map
  map = []
  200.times { map << Array.new(1000, '.') }
  map
end

def populate_rocks(map)
  File.foreach('input.txt', chomp: true) do |line|
    points = line.split(' -> ')
    (0..(points.count - 2)).each do |i|
      pair = points[i..(i + 1)].map { |s| s.split(',').map(&:to_i) }.sort
      (pair[0][0]..pair[1][0]).each do |x|
        (pair[0][1]..pair[1][1]).each do |y|
          map[y][x] = '#'
        end
      end
    end
  end
end

def drop_sand_unit_into(map)
  x = 500
  y = 0

  loop do
    return true if y >= 199

    if map[y + 1][x] == '.'
      y += 1
    elsif map[y + 1][x - 1] == '.'
      y += 1
      x -= 1
    elsif map[y + 1][x + 1] == '.'
      y += 1
      x += 1
    else
      map[y][x] = 'o'
      return false
    end
  end
end

def drop_sand_into(map)
  sand_units = 0
  loop do
    return sand_units if drop_sand_unit_into(map)

    sand_units += 1
  end
end

map = init_map
populate_rocks(map)
p drop_sand_into(map)
