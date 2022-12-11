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

def perform_turn(monkeys, monkey, lowest_common_multiple)
  while monkey.items.count > 0
    increased_worry = monkey.perform_inspection

    # Since the only comparison we're doing with these worry values is checking to see
    # if they're multiples of each monkey's test_divisor, we can reduce the values without
    # affecting those comparisons by dividing each value by the lowest common multiple
    # of all of the worry values and taking the remainder.
    #
    # Reducing values in this way (or in SOME way) is necessary because all of the
    # multiplication and exponentiation of the values we're doing causes the values to
    # become huge after several hundred rounds, to the point where the program takes
    # forever to run otherwise.
    relieved_worry = increased_worry % lowest_common_multiple

    throw_item(monkeys, monkey, relieved_worry)
  end
end

def perform_round(monkeys, lowest_common_multiple)
  monkeys.each do |monkey|
    perform_turn(monkeys, monkey, lowest_common_multiple)
  end
end

def monkey_business(monkeys)
  monkeys.map(&:inspections).sort.last(2).reduce(:*)
end

monkeys = init_monkeys

# The lowest common multiple can be found by just multiplying all of the
# test_divisor values together because they all happen to be prime numbers.
lowest_common_multiple = monkeys.map(&:test_divisor).reduce(&:*)

10_000.times do
  perform_round(monkeys, lowest_common_multiple)
end

p monkey_business(monkeys)
