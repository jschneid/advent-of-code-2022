class Monkey
  attr_accessor :items
  attr_accessor :test_divisor
  attr_accessor :operation
  attr_accessor :operand
  attr_accessor :true_target_monkey
  attr_accessor :false_target_monkey
  attr_accessor :inspections

  def initialize(data)
    @items = data[1].split[2..].map(&:to_i)
    @test_divisor = data[3].split.last.to_i

    if data[2].end_with?('old * old')
      @operation = :square
    else
      tokenized_operation_line = data[2].split
      @operand = data[2].split[5].to_i
      @operation = if tokenized_operation_line[4] == '+'
                     :add
                   else
                     :multiply
                   end
    end

    @true_target_monkey = data[4].split.last.to_i
    @false_target_monkey = data[5].split.last.to_i

    @inspections = 0
  end

  def increased_worry
    case @operation
    when :square
      return items[0] * items[0]
    when :add
      return items[0] + @operand
    when :multiply
      return items[0] * @operand
    end
  end

  def perform_inspection
    @inspections += 1
    increased_worry
  end
end

def init_monkeys
  monkeys = []
  data = File.readlines('input.txt', chomp:true)
  line_index = 0

  while line_index < data.count
    monkeys << Monkey.new(data[line_index..(line_index + 5)])
    line_index += 7
  end

  monkeys
end

def throw_item(monkeys, monkey, relieved_worry)
  if relieved_worry % monkey.test_divisor == 0
    monkeys[monkey.true_target_monkey].items << relieved_worry
  else
    monkeys[monkey.false_target_monkey].items << relieved_worry
  end
  monkey.items.shift
end

def perform_turn(monkeys, monkey)
  while monkey.items.count > 0
    increased_worry = monkey.perform_inspection
    relieved_worry = increased_worry / 3
    throw_item(monkeys, monkey, relieved_worry)
  end
end

def perform_round(monkeys)
  monkeys.each do |monkey|
    perform_turn(monkeys, monkey)
  end
end

def monkey_business(monkeys)
  monkeys.map(&:inspections).sort.last(2).reduce(:*)
end

monkeys = init_monkeys

20.times do
  perform_round(monkeys)
end

p monkey_business(monkeys)
