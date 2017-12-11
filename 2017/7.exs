defmodule Cheese do
  def parse(str) do
    line =
      ~r/(?<name>\w+) \((?<weight>\d+)\){1}( -> (?<above>(.*)))*/
      |> Regex.named_captures(str)
      |> Map.update!("above", fn(x)->
        case x do
          ""  -> []
          _ -> String.split(x, ", ")
        end
      end)

    [line["name"]] ++ line["above"]
  end

  def build_dict(lines) do
    lines
    |> List.flatten
    |> Enum.group_by(&(&1))
    |> Enum.map(fn({k, v}) -> {k, Enum.count(v)} end)
    |> Enum.min_by(fn({_k, v})-> v end)
  end
end

defmodule Tower do
  def parse(str) do
    ~r/(?<name>\w+) \((?<weight>\d+)\){1}( -> (?<above>(.*)))*/
    |> Regex.named_captures(str)
    |> Map.update!("weight", &String.to_integer/1)
    |> Map.update!("above", fn(x)->
      case x do
        ""  -> []
        _ -> String.split(x, ", ")
      end
    end)
  end

  def build(%{"above" => []} = base, _programs), do: base
  def build(%{"above" => above} = base, programs) do
    above_programs =
      programs
      |> Enum.filter(fn(program) -> program["name"] in above end)
      |> Enum.map(fn(program) -> build(program, programs) end)

    Map.replace(base, "above", above_programs)
  end


  def expected(parent) do
    s = parent["weight"]

    exp_with_weight = 
      for child <- parent["above"] do
        [expected(child), child["weight"]]
      end

    exp =
      exp_with_weight
      |> Enum.map(fn([e, _ws])-> e end)

    w = Enum.group_by(exp, &(&1))

    if Enum.count(w) > 1 do
      IO.inspect(exp_with_weight, charlists: :as_list)
      IO.inspect(w, charlists: :as_list)
    end

    exp
    |> Enum.sum
    |> Kernel.+(s)
  end
end


{:ok, txt} = File.read("7.txt")


# txt = 
"""
pbga (66)
xhth (57)
ebii (61)
padx (45) -> pbga, havc, qoyq
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""

lines =
  txt
  |> String.split("\n", trim: true)

{base_name, _} =
  lines
  |> Enum.map(&Cheese.parse/1)
  |> Cheese.build_dict


%{true => [base], false => programs} =
  lines
  |> Enum.map(&Tower.parse/1)
  |> Enum.group_by(fn(%{"name" => name}) ->
    name == base_name
  end)

base
|> Tower.build(programs)
|> Tower.expected
|> IO.inspect
