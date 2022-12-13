def values_in_correct_order?(left, right)
  if left.is_a?(Integer) && right.is_a?(Integer)
    return (left < right) if left != right

    return nil
  end

  if right.is_a?(Integer)
    right = [right]
  elsif left.is_a?(Integer)
    left = [left]
  end

  index = 0
  loop do
    return nil if index >= left.length && index >= right.length
    return true if index >= left.length
    return false if index >= right.length

    values_at_this_index_in_correct_order = values_in_correct_order?(left[index], right[index])
    return values_at_this_index_in_correct_order unless values_at_this_index_in_correct_order.nil?

    index += 1
  end
end

data = File.readlines('input.txt', chomp: true)
line_index = 0
sum_of_correctly_ordered_pair_indices = 0

while line_index < data.count
  left = eval(data[line_index])
  right = eval(data[line_index + 1])

  sum_of_correctly_ordered_pair_indices += (line_index / 3 + 1) if values_in_correct_order?(left, right)

  line_index += 3
end

p sum_of_correctly_ordered_pair_indices




