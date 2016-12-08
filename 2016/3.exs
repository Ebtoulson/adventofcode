{:ok, txt} = File.read("3.txt")

defmodule TriangleParser do
  def parse(line) do
    line
    |> String.split(" ")
    |> Enum.filter(fn(x) -> x != "" end)
    |> Enum.map(&String.to_integer/1)
  end

  def valid?(sides) do
    max = sides |> Enum.max
    rest =
      sides
      |> List.delete(max)
      |> Enum.sum

    rest > max
  end
end


defmodule Part1 do
  def solve(rows) do
    rows
    |> Enum.map(&TriangleParser.valid?/1)
    |> Enum.filter(fn(x) -> x end)
    |> Enum.count
    |> IO.inspect 
  end
end

txt
|> String.split("\n")
|> Enum.map(&TriangleParser.parse/1)
|> Part1.solve


defmodule Part2 do
  def column(grid, n) do
    Enum.map(grid, fn(t) -> Enum.at(t, n) end)
  end

  def solve(rows) do
    rows
    |> (fn(grid) -> [column(grid, 0), column(grid, 1), column(grid, 2)] end).()
    |> List.flatten
    |> Enum.chunk(3)
    |> Enum.map(&TriangleParser.valid?/1)
    |> Enum.filter(fn(x) -> x end)
    |> Enum.count
    |> IO.inspect
  end
end

txt
|> String.split("\n")
|> Enum.map(&TriangleParser.parse/1)
|> Part2.solve