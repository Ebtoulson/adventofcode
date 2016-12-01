input = "1113122113"

50.times do |i|
 input = input.chars.chunk{|c| c}.to_a.flat_map{|a| [a[1].size, a[0]]}.join
end

puts input.size
