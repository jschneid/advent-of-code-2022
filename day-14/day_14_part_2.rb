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

def add_bedrock(map)
  y = 199
  y -= 1 until map[y].include?('#')

  map[y + 2].each_index do |x|
    map[y + 2][x] = '#'
  end
end

def drop_sand_unit_into(map)
  x = 500
  y = 0

  loop do
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
      return
    end
  end
end

def drop_sand_into(map)
  sand_units = 0
  loop do
    drop_sand_unit_into(map)
    sand_units += 1

    return sand_units if map[0][500] == 'o'
  end
end

map = init_map
populate_rocks(map)
add_bedrock(map)
p drop_sand_into(map)
