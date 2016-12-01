ON = '#'
OFF = '.'

@matrix = IO.read("./18_inputs.txt").split("\n").map do |line|
  line.split('')
end

@matrix[0][0] = '#'
@matrix[0][@matrix[0].size-1] = '#'
@matrix[@matrix.size-1][0] = '#'
@matrix[@matrix.size-1][@matrix[0].size-1] = '#'

def get_value(row, column)
  if row < 0 || row >= @matrix[0].size || column < 0 || column >= @matrix.size
    OFF
  else
    @matrix[row][column]
  end
end

def get_square_coordinates(row, column)
  (row - 1).upto(row+1).map do |r|
    (column - 1).upto(column + 1).map do |c|
      [r, c] unless (r == row && c == column)
    end
  end
end

def get_neighbors(row, column)
  get_square_coordinates(row, column).map do |row|
    row.compact.map do |r, c|
      get_value(r, c)
    end
  end
end

def count_neighbors(row, column)
  coordinates = get_neighbors(row, column)
  coordinates.flatten.count{|c| c == ON}
end

def next_state(current_state, neighbor_count)
  if current_state == ON
    [2, 3].include?(neighbor_count) ? ON : OFF
  elsif current_state == OFF
    neighbor_count == 3 ? ON : OFF
  end
end

def corner?(row, column)
  [0, @matrix.size-1].include?(row) && [0, @matrix[0].size-1].include?(column)
end

STEPS = 100

1.upto(STEPS) do
  new_matrix = Marshal.load(Marshal.dump(@matrix))

  @matrix.each_with_index do |rows, r|
    rows.each_with_index do |light, c|
      count = count_neighbors(r, c)
      if corner?(r, c)
        new_matrix[r][c] = '#'
      else
        new_matrix[r][c] = next_state(light, count)
      end
    end
  end

  @matrix = new_matrix
end

count = 0
@matrix.each do |row|
  puts row.inspect
  count += row.count{|r| r == ON}
end
puts count
