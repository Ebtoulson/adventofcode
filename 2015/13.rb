seating = IO.read("./13_seating.txt").split("\n").map do |line|
  p, sign, num, p2 = /(.+) .+ (gain|lose) (\d+) .* (.+)+/.match(line.sub('.', '')).captures
  num = ('-' + num) if sign == 'lose'

  [p, p2, num.to_i]
end

people = seating.map{|s| s[0]}.uniq << 'Me'

seating_dict = seating.inject({}) do |nh, ar|
  nh.merge!({[ar[0], ar[1]] => ar[2]})
end

possible_seats = people.permutation.to_a.map!{|s| (s << s[0]) }.map do |s|
  total = s.each_cons(2).map do |t|
    left, right = [t[0], t[1]], [t[1], t[0]]
    seating_dict.fetch(left, 0) + seating_dict.fetch(right, 0)
  end.reduce(:+)
end

puts possible_seats.max