class Monkey
  attr_reader :id, :operation, :value, :child_a, :child_b

  def initialize(id, operation, value, child_a, child_b)
    @id = id
    @operation = operation
    @value = value
    @child_a = child_a
    @child_b = child_b
  end

  def replace_child_id_strings_with_references(monkeys)
    @child_a = monkeys.detect { |monkey| monkey.id == @child_a }
    @child_b = monkeys.detect { |monkey| monkey.id == @child_b }
  end
end

def read_monkeys
  monkeys = []
  File.foreach('input.txt', chomp: true) do |line|
    tokenized_line = line.split
    id = tokenized_line[0][0..3]
    if tokenized_line.length == 2
      monkeys << Monkey.new(id, nil, tokenized_line[1].to_i, nil, nil)
    else
      monkeys << Monkey.new(id, tokenized_line[2], nil, tokenized_line[1], tokenized_line[3])
    end
  end
  monkeys
end

def arrange_monkeys_tree(monkeys)
  monkeys.each do |monkey|
    monkey.replace_child_id_strings_with_references(monkeys)
  end
  monkeys.detect { |monkey| monkey.id == 'root' }
end

def solve(monkey)
  return monkey.value unless monkey.value.nil?

  case monkey.operation
  when '+'
    solve(monkey.child_a) + solve(monkey.child_b)
  when '-'
    solve(monkey.child_a) - solve(monkey.child_b)
  when '*'
    solve(monkey.child_a) * solve(monkey.child_b)
  when '/'
    solve(monkey.child_a) / solve(monkey.child_b)
  end
end

monkeys = read_monkeys
root = arrange_monkeys_tree(monkeys)
p solve(root)
