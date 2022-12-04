pairs_with_overlap = 0

File.foreach('input.txt') do |line|
  section_assignments = line.split(',')

  first_section_assignment_parts = section_assignments[0].split('-').map(&:to_i)
  second_section_assignment_parts = section_assignments[1].split('-').map(&:to_i)

  pairs_with_overlap += 1 if (first_section_assignment_parts[0] <= second_section_assignment_parts[0] && first_section_assignment_parts[1] >= second_section_assignment_parts[0]) ||
                             (second_section_assignment_parts[0] <= first_section_assignment_parts[0] && second_section_assignment_parts[1] >= first_section_assignment_parts[0])
end

p pairs_with_overlap
