def values_in_correct_order?(left, right)
  return left <=> right if left.is_a?(Integer) && right.is_a?(Integer)

  if right.is_a?(Integer)
    right = [right]
  elsif left.is_a?(Integer)
    left = [left]
  end

  index = 0
  loop do
    return 0 if index >= left.length && index >= right.length
    return -1 if index >= left.length
    return 1 if index >= right.length

    values_at_this_index_in_correct_order = values_in_correct_order?(left[index], right[index])
    return values_at_this_index_in_correct_order unless values_at_this_index_in_correct_order.zero?

    index += 1
  end
end

data = File.readlines('input.txt', chomp: true).reject(&:empty?).map { |line| eval(line) }
data << [[2]] << [[6]]

data.sort! { |left, right| values_in_correct_order?(left, right) }

p (data.find_index([[2]]) + 1) * (data.find_index([[6]]) + 1)

