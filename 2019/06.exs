defmodule FileParser do
  def read(file \\ "06.txt") do
    file
    |> File.read!()
    |> String.split()
  end
end

defmodule Orbits do
  def total_orbits(map) do
    map
    |> generate_orbits()
    |> Map.values()
    |> count_paths()
  end

  def min_orbit_transfers(map) do
    %{"SAN" => san, "YOU" => you} = generate_orbits(map)

    san
    |> List.myers_difference(you)
    |> Keyword.take([:del, :ins])
    |> Keyword.values()
    |> count_paths()
  end

  defp count_paths(list_of_paths) do
    Enum.reduce(list_of_paths, 0, fn(paths, sum) ->
      Enum.count(paths) + sum
    end)
  end

  defp from_map(map) do
    map
    |> Enum.map(fn(orbit)->
      orbit
      |> String.split(")")
      |> Enum.reverse()
      |> List.to_tuple()
    end)
    |> Map.new()
  end

  # returns map of orbitors name and their paths
  defp generate_orbits(map) do
    orbits = from_map(map)
    orbiters = Map.keys(orbits)

    orbiters
    |> Enum.map(fn(orbiter) ->
      {orbiter, path_to_com(orbits, orbiter)}
    end)
    |> Map.new()
  end

  # creates a list of each orbit pointing to the next until there isn't another
  defp path_to_com(orbits, orbiter, path \\ []) do
    case Map.get(orbits, orbiter) do
      nil -> path
      next -> path_to_com(orbits, next, [next | path])
    end
  end
end

ExUnit.start()

defmodule AssertionTest do
  use ExUnit.Case, async: true

  test "part 1 examples" do
    map = ~w[COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L]
    assert Orbits.total_orbits(map) == 42
  end

  test "part 2 examples" do
    map = ~w[COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L K)YOU I)SAN]
    assert Orbits.min_orbit_transfers(map) == 4
  end
end

# FileParser.read()
# |> Orbits.total_orbits()
# |> IO.inspect()

FileParser.read()
|> Orbits.min_orbit_transfers()
|> IO.inspect()