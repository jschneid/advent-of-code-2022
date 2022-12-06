data = File.read('input.txt')
index = 4
index += 1 while data[(index - 4)..(index - 1)].chars.uniq.length < 4
p index
