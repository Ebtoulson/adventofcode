santas_list = IO.read("./8_characters.txt").split("\n")

total_chars = santas_list.inject(0) do |sum, chars|
  sum += chars.size
end

eval_chars = santas_list.inject(0) do |sum, chars|
  sum += eval(chars).size
end

File.open("double_escape.txt", "w"){|f| f.write(santas_list.map{|chars| chars.inspect }.join("\n")) }
double_escaped_list = IO.read("./double_escape.txt").split("\n")

escaped_chars = double_escaped_list.inject(0) do |sum, chars|
  sum += chars.size
end

puts escaped_chars - total_chars