defmodule Instructions do
  @doc "returns a tuple with next coordinates and current direction"
  def move(coordinates, direction, turn, spaces) do
    direction = calc_direction(direction, turn)
    [x, y] = coordinates
    [move_x, move_y] = calc_coords(direction, spaces)
    {[x + move_x, y + move_y], direction}
  end

  @doc "returns a tuple with turn direction and number of spaces to move"
  def parse(input) do
    [_, turn, spaces] = Regex.run(~r/([RL])(\d+)/, input)
    {turn, String.to_integer(spaces)}
  end

  defp calc_direction(direction, turn) do
    case {direction, turn} do
      {:N, "L"} -> :W
      {:N, "R"} -> :E
      {:S, "L"} -> :E
      {:S, "R"} -> :W
      {:E, "L"} -> :N
      {:E, "R"} -> :S
      {:W, "L"} -> :S
      {:W, "R"} -> :N
    end
  end

  defp calc_coords(direction, spaces) do
    case direction do
      :N -> [0, spaces]
      :E -> [spaces, 0]
      :S -> [0, -spaces]
      :W -> [-spaces, 0]
    end
  end
end


{:ok, txt} = File.read("1.txt")

txt = 
  # txt
  "R8, R4, R4, L4, L8, L12, L8, L8"
  |> String.split(", ")
  |> Enum.map(&Instructions.parse(&1))

default_coords = [0, 0]
default_direction = :N


# {[x, y], _} =
#   txt
#   |> Enum.reduce({default_coords, default_direction},
#       fn({turn, spaces}, {coords, direction})->
#         Instructions.move(coords, direction, turn, spaces)
#       end
#     )

# IO.puts(abs(x) + abs(y))

defmodule Grid do
  def all_points([x1, y1], [x2, y2]) do
    movement =
      cond do
        x1 == x2 -> Enum.into(Enum.intersperse(Enum.to_list(y1..y2), x1), [x1])
        y1 == y2 -> Enum.into([y1], Enum.intersperse(Enum.to_list(x1..x2), y1))
      end

    movement |> Enum.chunk(2)
  end
end


{[_, _], _, used_coords} =
  txt
  |> Enum.reduce({default_coords, default_direction, [default_coords]},
      fn({turn, spaces}, {coords, direction, prev_coords})->
        {[x, y], dir} = Instructions.move(coords, direction, turn, spaces)
        all_points = tl(Grid.all_points(coords, [x, y]))
        {[x, y], dir, Enum.into(all_points, prev_coords)}
      end
    )

IO.inspect(used_coords, limit: :infinity)

Enum.with_index(used_coords)
|> Enum.find(fn({char, i}) -> Enum.count(Enum.slice(used_coords, 0..i), fn(x)-> x == char end) > 1 end)
|> IO.inspect
