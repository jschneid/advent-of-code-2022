def parse_crate_stacks_line(line, stacks)
  stack_index = 0
  x = 1
  while x < line.length
    if line[x] != ' '
      stacks[stack_index] ||= []
      stacks[stack_index] << line[x]
    end
    stack_index += 1
    x += 4
  end
end

def parse_crate_stacks(lines)
  stacks = []

  lines.reverse_each do |line|
    parse_crate_stacks_line(line, stacks)
  end

  stacks
end

def perform_crate_move(from_position, to_position, stacks)
  crate = stacks[from_position].pop
  stacks[to_position] << crate
end

def perform_crate_move_line(line, stacks)
  tokenized_line = line.split(' ')
  execution_count = tokenized_line[1].to_i
  from_position = tokenized_line[3].to_i - 1
  to_position = tokenized_line[5].to_i - 1
  execution_count.times do
    perform_crate_move(from_position, to_position, stacks)
  end
end

def perform_all_crate_moves(moves, stacks)
  moves.each do |move_line|
    perform_crate_move_line(move_line, stacks)
  end
end

def top_crates_string(stacks)
  stacks.map(&:last).join
end

lines = File.readlines('input.txt', chomp: true)
index_of_blank_line = lines.find_index('')

# We COULD just hard-code the starting position of the crate stacks
# from my specific input; but if I was interested in taking shortcuts:
#
# - (New for 2022!) I could just use an AI to solve this problem!
# - It's cooler to have a solution that works with ANY input
# - I could just skip participating in AoC entirely!
stacks = parse_crate_stacks(lines[0..(index_of_blank_line - 2)])

perform_all_crate_moves(lines[(index_of_blank_line + 1)..], stacks)

pp top_crates_string(stacks)
