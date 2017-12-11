defmodule Maze do
  def move(move_tuple, index \\ 0, count \\ 0) do
    with true <- index >= 0,
         true <- index < tuple_size(move_tuple),
         value <- elem(move_tuple, index) do
      offset = if value >= 3, do: -1, else: 1

      move_tuple
      |> Kernel.put_elem(index, value + offset)
      |> move(index + value, count + 1)
    else
      _ -> count
    end
  end
end


{:ok, txt} = File.read("5.txt")

txt
|> String.split("\n", trim: true)
|> Enum.map(&String.to_integer/1)
|> List.to_tuple()
|> Maze.move()
|> IO.puts
