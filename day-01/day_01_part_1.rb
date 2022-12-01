max_calories = 0
accumulated_calories = 0

File.foreach('input.txt') do |line|
  if line == "\n"
    max_calories = accumulated_calories if accumulated_calories > max_calories
    accumulated_calories = 0
  else
    accumulated_calories += line.to_i
  end
end

p max_calories
