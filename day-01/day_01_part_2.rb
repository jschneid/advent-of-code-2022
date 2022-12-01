accumulated_calories = 0
elf_calories = []

File.foreach('input.txt') do |line|
  if line == "\n"
    elf_calories << accumulated_calories
    accumulated_calories = 0
  else
    accumulated_calories += line.to_i
  end
end

elf_calories.sort!

p elf_calories[-1] + elf_calories[-2] + elf_calories[-3]
