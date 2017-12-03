defmodule Spreadsheet do
  def parse(txt) do
    txt
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row_list) do
    row_list
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end


defmodule Part1 do
  def solve(txt) do
    txt
    |> Spreadsheet.parse()
    |> Enum.reduce([], fn(curr, acc) ->
      acc ++ [Enum.max(curr) - Enum.min(curr)]
    end)
    |> Enum.sum
  end
end

defmodule Part2 do
  def solve(txt) do
    txt
    |> Spreadsheet.parse()
    |> Enum.reduce([], fn(curr, acc) ->
      acc ++ [find_evenly_divisble(curr)]
    end)
    |> Enum.sum
  end

  defp find_evenly_divisble(list) do
    Enum.find_value(list, fn(char) ->
      Enum.find_value(list, fn(x) ->
        with false <- char == x,
             0 <- rem(char, x) do
          div(char, x)
        else
          _ -> false
        end
      end)
    end)
  end
end

{:ok, txt} = File.read("2.txt")
# txt = """
# 5 9 2 8
# 9 4 7 3
# 3 8 6 5
# """
# IO.inspect Part1.solve(txt)
IO.inspect Part2.solve(txt)
