ingredients = IO.read("./15_ingredients.txt").split("\n").map do |line|
  name, *ingred_list = /(.+): .* (.*), .* (.*), .* (.*), .* (.*), .* (.*)/.match(line).captures
  {name => ingred_list.map(&:to_i)}
end.inject({}) { |nh, oh| nh.merge!(oh)}

recipes = ingredients.keys.repeated_combination(100).map do |combo|
  ingredients.keys.map do |i|
    [i, combo.count{|ing| ing == i}]
  end
end

scores = recipes.map do |recipe|
  quantities = recipe.map do |name, quantity|
    ingredients[name].map do |i|
      quantity * i
    end
  end

  quantity_totals = quantities.transpose.map do |x|
    sum = x.reduce(:+)
    sum < 0 ? 0 : sum
  end

  score = quantity_totals.slice(0,4).reduce(:*)
  calories = quantity_totals[4]

  [score, calories]
end

within_calories = scores.select do |score, calories|
  calories == 500
end

best = within_calories.max_by{|score, calories| score}
puts best.inspect