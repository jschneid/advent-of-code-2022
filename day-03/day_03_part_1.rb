def item_priority(item)
  return item.ord - 96 if item == item.downcase
  item.ord - 38
end

common_items_total_priorities = 0

File.readlines('input.txt', chomp: true).each do |line|
  first_compartment = line[0..line.length / 2]
  second_compartment = line[line.length / 2..]

  common_item = (first_compartment.chars & second_compartment.chars)[0]

  common_items_total_priorities += item_priority(common_item)
end

p common_items_total_priorities
