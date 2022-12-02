shape_that_loses_to = { 'C' => 'paper', 'A' => 'scissors', 'B' => 'rock' }
shape_that_ties = { 'A' => 'rock', 'B' => 'paper', 'C' => 'scissors' }
shape_that_defeats = { 'B' => 'scissors', 'C' => 'rock', 'A' => 'paper' }
shape_points = { 'rock' => 1, 'paper' => 2, 'scissors' => 3 }

total_score = 0

File.foreach('input.txt') do |line|
  opponent_shape = line[0]
  outcome = line[2]

  if outcome == 'X' # loss
    player_shape = shape_that_loses_to[opponent_shape]
  elsif outcome == 'Y' # tie
    total_score += 3
    player_shape = shape_that_ties[opponent_shape]
  else # Z (win)
    total_score += 6
    player_shape = shape_that_defeats[opponent_shape]
  end

  total_score += shape_points[player_shape]
end

p total_score
