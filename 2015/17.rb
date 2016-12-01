containers = IO.read("./17_inputs.txt").split("\n").map(&:to_i)

LITERS = 150

combinations = []

1.upto(containers.size) do |n|
  containers.combination(n).to_a.collect do |c|
    combinations << c if c.reduce(:+) == LITERS
  end
end

puts combinations.group_by {|c| c.size }.first[1].size