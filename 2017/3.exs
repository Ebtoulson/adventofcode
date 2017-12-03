# 37  36  35  34  33  32  31
# 38  17  16  15  14  13  30
# 39  18   5   4   3  12  29
# 40  19   6   1   2  11  28
# 41  20   7   8   9  10  27
# 42  21  22  23  24  25  26
# 43  44  45  46  47  48  49


# 1 -> 1
# 2 -> 9
# 3 -> 25
# 4 -> 49

# 1^2
# 3^2
# 5^2
# 7^2

defmodule Spiral do
  def build_layers(num) do

    Stream.iterate(1, &(&1 + 2))
    |> Stream.take_while(fn(x) ->
      sq = :math.pow(x, 2)
      prev_sq = :math.pow(x - 2, 2)
      num >= sq || (prev_sq < num && x != 1)
    end)
    |> Stream.map(&( Kernel.abs(:math.pow(&1, 2) - num)) )
    |> Enum.to_list
    |> Enum.min
    |> IO.inspect
  end
end

Spiral.build_layers(1)
Spiral.build_layers(12)
Spiral.build_layers(23)
Spiral.build_layers(368078)


# part 2 - https://oeis.org/A141481
