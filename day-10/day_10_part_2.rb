def get_scheduled_increases
  scheduled_increases = Array.new(1000, 0)

  index = 0
  File.foreach('input.txt', chomp: true) do |line|
    tokenized_line = line.split(' ')
    if tokenized_line[0] == 'addx'
      index += 2
      scheduled_increases[index] += tokenized_line[1].to_i
    else # 'noop'
      index += 1
    end
  end

  scheduled_increases
end

def render_pixels_for_cycles(scheduled_increases)
  register_x = 1

  pixels = Array.new(240, '.')
  (0..239).each do |cycle|
    register_x += scheduled_increases[cycle]

    x = cycle % 40
    pixels[cycle] = '#' if (register_x - x).abs <= 1
  end

  pixels
end

def draw(pixels)
  (0..5).each do |y|
    p pixels[(y * 40)..((y + 1) * 40) - 1].join
  end
end

scheduled_increases = get_scheduled_increases
pixels = render_pixels_for_cycles(scheduled_increases)
draw(pixels)
