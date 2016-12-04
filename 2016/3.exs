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

txt
|> String.split("\n")
|> Enum.map(&TriangleParser.parse/1)
|> Enum.map(&TriangleParser.valid?/1)
|> Enum.filter(fn(x) -> x end)
|> Enum.count
|> IO.inspect