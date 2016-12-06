{:ok, msg} = File.read("6.txt")

defmodule Chars do
  def most_common(char_list) do
    char_list
    |> Enum.group_by(fn(x) -> x end)
    |> Enum.map(fn({k, v}) -> {k, Enum.count(v)} end)
    |> Enum.max_by(fn({_, v}) -> v end)
  end

  def least_common(char_list) do
    char_list
    |> Enum.group_by(fn(x) -> x end)
    |> Enum.map(fn({k, v}) -> {k, Enum.count(v)} end)
    |> Enum.min_by(fn({_, v}) -> v end)
  end
end


defmodule Part1 do
  def solve(columns) do
    chars = for c <- 0..(columns |> List.first |> Enum.count |> Kernel.-(1)) do
      columns
      |> Enum.map(&Enum.at(&1, c))
      |> Chars.most_common
      |> (fn({k, _}) -> k end).()
    end

    chars
    |> Enum.join
    |> IO.inspect
  end
end

defmodule Part2 do
  def solve(columns) do
    chars = for c <- 0..(columns |> List.first |> Enum.count |> Kernel.-(1)) do
      columns
      |> Enum.map(&Enum.at(&1, c))
      |> Chars.least_common
      |> (fn({k, _}) -> k end).()
    end

    chars
    |> Enum.join
    |> IO.inspect
  end
end

columns = msg
|> String.split("\n")
|> Enum.map(&String.graphemes/1)

Part1.solve(columns)
Part2.solve(columns)