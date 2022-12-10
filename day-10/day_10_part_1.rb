register_x = 1
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

six_signal_strengths_sum = 0

(1..220).each do |cycle|
  six_signal_strengths_sum += (cycle * register_x) if [20, 60, 100, 140, 180, 220].include?(cycle)

  register_x += scheduled_increases[cycle]
end

p six_signal_strengths_sum

