routes = IO.read("./9_routes.txt").split("\n")

routes.map!{|route| /(\w+) to (\w+) = (\d+)/.match(route).captures }

from_distances = routes.map{|r| Hash[[r[0], r[1]], r[2].to_i] }
to_distances = routes.map{|r| Hash[[r[1], r[0]], r[2].to_i] }

distance_hash = (from_distances + to_distances).inject({}) { |nh, oh| nh.merge!(oh)}

locations = (routes.map{|r| r[0]} + routes.map{|r| r[1]}).uniq

totals = locations.permutation.to_a.map do |route|
  route.each_cons(2).to_a.map do |key|
    distance_hash[key]
  end 
end

totals = totals.reject{|d| d.include?(nil)}.map{|r| r.reduce(:+)}

puts totals.min
puts totals.max