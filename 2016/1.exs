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
default_coords = [0, 0]
default_direction = :N

{[x, y], _} =
  txt
  |> String.split(", ")
  |> Enum.map(&Instructions.parse(&1))
  |> Enum.reduce({default_coords, default_direction},
      fn({turn, spaces}, {coords, direction})->
        Instructions.move(coords, direction, turn, spaces)
      end
    )

IO.puts(abs(x) + abs(y))