def item_priority(item)
  return item.ord - 96 if item == item.downcase
  item.ord - 38
end

total_group_badge_priorities = 0

elf_group = []
File.readlines('input.txt', chomp: true).each_with_index do |line, index|
  elf_group << line

  next unless index % 3 == 2

  badge_item = (elf_group[0].chars & elf_group[1].chars & elf_group[2].chars)[0]
  total_group_badge_priorities += item_priority(badge_item)
  elf_group = []
end

p total_group_badge_priorities
