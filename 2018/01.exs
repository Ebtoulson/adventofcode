defmodule Frequency do
  @filename "01.txt"

  def parse(input \\ @filename) do
    input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def sum do
    parse()
    |> Enum.sum()
  end

  def duplicate(input \\ parse(), previous \\ [0], current \\ 0) do
    dup = find_duplicate(input, previous, current)
    case dup do
      {:ok, val} -> val
      [prev, current] -> duplicate(input, prev, current)
    end
  end

  defp find_duplicate(input, previous, current) do
    Enum.reduce_while(input, [previous, current],
      fn(x, [prev, sum]) ->
        freq = sum + x

        if freq in prev do
          {:halt, {:ok, freq}}
        else
          {:cont, [[freq | prev], freq]}
        end
      end
    )
  end
end

IO.puts(Frequency.sum())
IO.inspect(Frequency.duplicate())