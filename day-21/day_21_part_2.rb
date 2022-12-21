class Monkey
  attr_reader :id, :operation, :value, :child_a, :child_b, :has_human_descendant

  def initialize(id, operation, value, child_a, child_b)
    @id = id
    @operation = operation
    @value = value
    @child_a = child_a
    @child_b = child_b
    @has_human_descendant = false
  end

  def replace_child_id_strings_with_references(monkeys)
    @child_a = monkeys.detect { |monkey| monkey.id == @child_a }
    @child_b = monkeys.detect { |monkey| monkey.id == @child_b }
  end

  def update_has_human_descendant
    @has_human_descendant = if id == 'humn'
                              true
                            elsif child_a.nil? && child_b.nil?
                              false
                            else
                              child_a.update_has_human_descendant || child_b.update_has_human_descendant
                            end
    @has_human_descendant
  end

  def inhuman_child
    child_a.has_human_descendant ? child_b : child_a
  end

  def human_child
    child_a.has_human_descendant ? child_a : child_b
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

def solve_root(root)
  target_value = solve_part_1(root.inhuman_child)

  solve(root.human_child, target_value)
end

def solve(monkey, target_value)
  if monkey.id == 'humn'
    p target_value
    return nil
  end

  inhuman_result = solve_part_1(monkey.inhuman_child)

  new_target_value = case monkey.operation
                     when '+'
                       target_value - inhuman_result
                     when '-'
                       if monkey.inhuman_child == monkey.child_a
                         inhuman_result - target_value
                       else
                         target_value + inhuman_result
                       end
                     when '*'
                       target_value / inhuman_result
                     when '/'
                       if monkey.inhuman_child == monkey.child_a
                         inhuman_result / target_value
                       else
                         target_value * inhuman_result
                       end
                     end

  solve(monkey.human_child, new_target_value)
end

def solve_part_1(monkey)
  return monkey.value unless monkey.value.nil?

  case monkey.operation
  when '+'
    solve_part_1(monkey.child_a) + solve_part_1(monkey.child_b)
  when '-'
    solve_part_1(monkey.child_a) - solve_part_1(monkey.child_b)
  when '*'
    solve_part_1(monkey.child_a) * solve_part_1(monkey.child_b)
  when '/'
    solve_part_1(monkey.child_a) / solve_part_1(monkey.child_b)
  end
end

monkeys = read_monkeys
root = arrange_monkeys_tree(monkeys)
root.update_has_human_descendant

solve_root(root)
