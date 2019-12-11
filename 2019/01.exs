# Fuel required to launch a given module is based on its mass. Specifically, to find the fuel required for a module, take its mass, divide by three, round down, and subtract 2.

# For example:

# For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
# For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
# For a mass of 1969, the fuel required is 654.
# For a mass of 100756, the fuel required is 33583.
# The Fuel Counter-Upper needs to know the total fuel requirement. To find it, individually calculate the fuel needed for the mass of each module (your puzzle input), then add together all the fuel values.

# What is the sum of the fuel requirements for all of the modules on your spacecraft?

defmodule FileParser do
  def read(file \\ "01.txt") do
    file
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Fuel do
	def calculate(mass) do
		mass
    |> Integer.floor_div(3)
    |> Kernel.-(2)
	end

  def total_with_fuel(mass) do
    Stream.iterate(mass, &calculate/1)
    |> Enum.take_while(fn(f) -> f > 0 end)
    |> Enum.drop(1)
    |> Enum.sum()
  end
end

FileParser.read()
|> Enum.map(&Fuel.total_with_fuel/1)
|> Enum.sum()
|> IO.puts()

ExUnit.start()

defmodule AssertionTest do
  use ExUnit.Case, async: true

  test "examples" do
    assert Fuel.calculate(12) == 2
    assert Fuel.calculate(14) == 2
    assert Fuel.calculate(1969) == 654
    assert Fuel.calculate(100756) == 33583
  end
end