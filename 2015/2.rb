def surface_area(length, width, height)
  sides = [length*width, width*height, height*length]
  smallest_side = sides.min

  area = sides.inject(0){|sum, s| sum += s * 2}
  area + smallest_side
end

def ribbon_length(length, width, height)
  sides = [length, width, height]

  shortest_perimeter = sides.sort.take(2).reduce(:+) * 2
  bow = sides.reduce(:*)

  bow + shortest_perimeter
end


presents = IO.read("./2_presents.txt").split("\n").map do |p|
  p.split('x').map(&:to_i)
end


# total_area = presents.map do |p|
#   l,w,h = p
#   surface_area(l,w,h)
# end.reduce(:+)


total_length = presents.map do |p|
  l,w,h = p
  ribbon_length(l,w,h)
end.reduce(:+)


puts total_length