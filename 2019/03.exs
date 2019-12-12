defmodule FileParser do
  def read(file \\ "03.txt") do
    file
    |> File.read!()
    |> String.split("\n")
  end
end

defmodule Wires do
  def closest_intersection(paths, all_intersections \\ false) do
    paths =
      paths
      |> List.wrap()
      |> Enum.map(&parse_path/1)

    {_, circuit} =
      Enum.reduce(paths, {1, %{{0,0} => "o"}}, fn(path, {path_num, circuit}) ->
        {_, circuit} = 
          Enum.reduce(path, {{0,0}, circuit}, fn({dir, dist}, {current_position, circuit}) ->
            next_position = next_coord(dir, dist, current_position)
            {next_position, update_circuit(circuit, path_num, current_position, next_position)}
          end)
        {path_num + 1, circuit}
      end)

    intersection_points = Enum.filter(circuit, fn({_k, v}) ->
      v != "o" && Enum.count(Enum.uniq(v)) > 1
    end)

    intersections_with_distance =
      intersection_points
      |> Enum.map(fn({{x, y}, _}) -> {{x, y}, abs(x) + abs(y)} end)

    if !all_intersections do
      {_point, distance} = Enum.min_by(intersections_with_distance, fn({_, dist}) -> dist end)
      distance
    else
      Enum.map(intersection_points, &elem(&1, 0))
    end
  end

  def closest_intersection_travel(original_paths) do
    paths =
      original_paths
      |> List.wrap()
      |> Enum.map(&parse_path/1)

    coord_paths =
      Enum.reduce(paths, [], fn(path, coords_acc) ->
        {_, coords} = 
          Enum.reduce(path, {{0,0}, []}, fn({dir, dist}, {current_position, original_coords}) ->
            next_position = next_coord(dir, dist, current_position)
            coords = get_coordinators(current_position, next_position)
            {
              next_position,
              coords
              |> Enum.reverse()
              |> Enum.concat(original_coords)
            }
          end)
        
        [Enum.reverse(coords) | coords_acc]
      end)

    intersections = closest_intersection(original_paths, true)
    [first, second] = coord_paths

    for intersection <- intersections do
      {_rest, path1_to} = first |> Enum.reverse() |> Enum.split_while(&(&1 != intersection))
      {_rest, path2_to} = second |> Enum.reverse() |> Enum.split_while(&(&1 != intersection))

      Enum.count(path1_to) + Enum.count(path2_to)
    end
    |> Enum.min
  end

  def parse_path(path) do
    path
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn(dir_dist) ->
      {dir, dist} = String.split_at(dir_dist, 1)

      {dir, String.to_integer(dist)}
    end)
  end

  def next_coord("L", dist, {x, y}), do: {x - dist, y}
  def next_coord("R", dist, {x, y}), do: {x + dist, y}
  def next_coord("U", dist, {x, y}), do: {x, y + dist}
  def next_coord("D", dist, {x, y}), do: {x, y - dist}

  def get_coordinators({curr_x, curr_y} = current, {next_x, next_y}) do
    for x <- curr_x..next_x,
        y <- curr_y..next_y,
        {x, y} != current do
      {x, y}
    end
  end

  def update_circuit(circuit, path_num, current, next) do
    coords = get_coordinators(current, next)

    Enum.reduce(coords, circuit, fn(coord, acc) ->
      Map.update(acc, coord, [path_num], fn(val) ->
        case val do
          "o" -> "o"
           _ -> [path_num | val]
         end
       end)
    end)
  end
end

ExUnit.start()

defmodule AssertionTest do
  use ExUnit.Case, async: true

  test "part 1 examples" do
    assert Wires.closest_intersection(["R8,U5,L5,D3", "U7,R6,D4,L4"]) == 6
    assert Wires.closest_intersection(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]) == 159

    assert Wires.closest_intersection(["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]) == 135
  end

  test "part 2 examples" do
    assert Wires.closest_intersection_travel(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]) == 610
    assert Wires.closest_intersection_travel(["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]) == 410
  end
end



# FileParser.read()
# |> Wires.closest_intersection()
# |> IO.inspect()

FileParser.read()
|> Wires.closest_intersection_travel()
|> IO.inspect(label: :answer)