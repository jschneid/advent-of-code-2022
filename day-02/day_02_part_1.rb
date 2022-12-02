shape_points = { 'X' => 1, 'Y' => 2, 'Z' => 3 }
shape_defeats = { 'X' => 'C', 'Y' => 'A', 'Z' => 'B' }
shape_ties = { 'X' => 'A', 'Y' => 'B', 'Z' => 'C' }

total_score = 0

File.foreach('input.txt') do |line|
  total_score += shape_points[line[2]]
  total_score += 6 if shape_defeats[line[2]] == line[0]
  total_score += 3 if shape_ties[line[2]] == line[0]
end

p total_score
