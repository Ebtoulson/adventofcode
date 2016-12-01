ITEMS = {
  children: 3,
  cats: 7,
  samoyeds: 2,
  pomeranians: 3,
  akitas: 0,
  vizslas: 0,
  goldfish: 5,
  trees: 3,
  cars: 2,
  perfumes: 1
}

# cats and trees greater than whats listed
# pomeranians and goldfish fewer than whats listed

def match?(k, v)
  case k
  when :pomeranians || :goldfish
    ITEMS[k] > v
  when :cats || :trees
    ITEMS[k] < v
  else
    ITEMS[k] == v
  end
end

# Sue 1: goldfish: 9, cars: 0, samoyeds: 9
# Sue 2: perfumes: 5, trees: 8, goldfish: 8

IO.read("./16_sues.txt").split("\n").each do |sue|
  num, detected = /Sue (\d+): (.*)/.match(sue).captures
  detected = detected.split(', ').map do |a|
    x,y = a.split(': ')
    [x.to_sym, y.to_i]
  end

  matches = detected.map do |k,v|
    match?(k,v)
  end

  puts num if matches.all?
end