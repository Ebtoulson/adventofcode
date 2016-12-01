def house(current, m)
  x,y=current
  case m
  when "^" then [x+1, y]
  when "v" then [x-1, y]
  when ">" then [x, y+1]
  when "<" then [x, y-1]
  end
end


movements = IO.read("./3_movements.txt").chars

santa = []
robot = []

movements.each_with_index { |v,i| (i.odd? ? robot : santa) << v }

santa_current = [0,0]
santa_houses = []

santa.map do |m|
  santa_houses << santa_current
  santa_current = house(santa_current, m)
end

robot_current = [0,0]
robot_houses = []

robot.map do |m|
  robot_houses << robot_current
  robot_current = house(robot_current, m)
end

houses = santa_houses + robot_houses
puts houses.uniq.count