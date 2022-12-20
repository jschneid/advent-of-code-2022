def read_file
  file = []
  File.foreach('input.txt', chomp: true) do |line|
    file << line.to_i * 811589153
  end
  file
end

def mix(move, index, file, indexes)
  value = file.delete_at(index)
  file.rotate!(move)
  file.insert(index, value)

  value = indexes.delete_at(index)
  indexes.rotate!(move)
  indexes.insert(index, value)
end

def grove_coordinates(file)
  index_of_zero = file.find_index(0)
  [
    file[(index_of_zero + 1000) % file.length],
    file[(index_of_zero + 2000) % file.length],
    file[(index_of_zero + 3000) % file.length]
  ]
end

file = read_file
moves = read_file.clone
indexes = (0..file.length - 1).to_a

10.times do
  (0..file.length - 1).each do |i|
    mix(moves[i], indexes.find_index(i), file, indexes)
  end
end

p grove_coordinates(file)
p grove_coordinates(file).reduce(&:+)
