require 'matrix'

def get_square_coordinates(point1, point2)
  x1, y1 = point1
  x2, y2 = point2

  indexes = []
  x1.upto(x2) do |x|
    y1.upto(y2) do |y|
      indexes << [x, y]
    end
  end
  indexes
end

def apply_ops(op, num)
  case op
  when 'turn on' then num + 1
  when 'turn off' then ((num - 1) <= 0) ? 0 : (num - 1)
  when 'toggle' then num + 2
  end
end

instructions = IO.read("./6_instructions.txt").split("\n")
instructions.map! do |line|
  op = /^(.*?)\d/.match(line).captures[0].strip
  x1, y1 = /^.*?(\d+),(\d+)/.match(line).captures.map(&:to_i)
  x2, y2 = /^.*?through (\d+),(\d+)/.match(line).captures.map(&:to_i)

  [op, [x1,y1], [x2,y2]]
end

SIZE = 1000
matrix = Array.new(SIZE) { Array.new(SIZE, 0) }

instructions.each do |op, point1, point2|
  get_square_coordinates(point1, point2).each do |index|
    value = matrix[index[0]][index[1]]
    matrix[index[0]][index[1]] = apply_ops(op, value)
  end
end

count = matrix.map{|row| row.reduce(:+)}.reduce(:+)

puts count