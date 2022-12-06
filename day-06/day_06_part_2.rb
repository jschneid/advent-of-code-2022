data = File.read('input.txt')
index = 14
index += 1 while data[(index - 14)..(index - 1)].chars.uniq.length < 14
p index
