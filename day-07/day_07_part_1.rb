def increase_size_of_directories_in_stack(directory_stack, directory_sizes, file_size)
  directory_stack.each_index do |index|

    # There can be distinct directories in different places in the filesystem with the same name.
    # Therefore, we need to track directory sizes by the fully-specified path, not just the individual
    # directory name.
    directory_name = directory_stack[0..index].join('/')

    directory_sizes[directory_name] = 0 unless directory_sizes.key?(directory_name)
    directory_sizes[directory_name] += file_size
  end
end

def total_size_of_directories_under_threshold(directory_sizes, threshold)
  total_size = 0
  directory_sizes.values.each do |size|
    total_size += size if size <= threshold
  end
  total_size
end

directory_stack = ['/']
directory_sizes = {}

File.foreach('input.txt', chomp: true) do |line|
  tokenized_line = line.split(' ')
  if line == '$ cd /'
    # noop; this only appears once, in the first line of the input
  elsif line == '$ cd ..'
    directory_stack.pop
  elsif line.start_with?('$ cd')
    directory_stack << tokenized_line[2]
  elsif line == '$ ls'
    # noop
  elsif line.start_with?('dir')
    # noop
  else
    increase_size_of_directories_in_stack(directory_stack, directory_sizes, tokenized_line[0].to_i)
  end
end

p total_size_of_directories_under_threshold(directory_sizes, 100_000)
