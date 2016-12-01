deer = IO.read("./14_instructions.txt").split("\n").map do |line|
  d, speed, duration, rest = /(.+) can fly (\d+) km\/s for (\d+)+ seconds, .* (\d+) seconds\./.match(line).captures
  [d, speed.to_i, duration.to_i, rest.to_i, 0, 0]
end

seconds = 2503

def distance_traveled(second, speed, duration, rest)
  current = second % (duration + rest)
  (current != 0 && current <= duration) ? speed : 0
end

1.upto(seconds).each do |s|
  deer.map! do |de|
    d, speed, duration, rest, current, points = de
    current += distance_traveled(s, speed, duration, rest)
    [d, speed, duration, rest, current, points]
  end

  max_distance = deer.max_by{|d| d[4]}[4]

  deer.map! do |d|
    if d[4] == max_distance
      d[5] += 1
    end
    d
  end
end

puts deer.max_by{|d| d[5]}.inspect
