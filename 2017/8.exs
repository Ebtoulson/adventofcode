defmodule Instructions do
  def parse(line) do
    ~r/^(?<var>\w+) (?<op>\w+) (?<param>.+) if (?<var2>\w+) (?<bool_op>.+) (?<check_val>.+)$/
    |> Regex.named_captures(line)
    |> Map.update!("op", fn(op) ->
      case op do
        "inc" -> "+"
        "dec" -> "-"
      end
    end)
  end

  def var_declaration(instructions) do
    instructions
    |> Enum.map(fn(i) ->
      { String.to_atom(Map.fetch!(i, "var")), 0 }
    end)
    |> Enum.uniq
    |> Kernel.++([{:max, 0}])
  end

  def code_declaration(instructions) do
    for i <- instructions do
      """
      #{i["var"]} = if #{i["var2"]} #{i["bool_op"]} #{i["check_val"]} do
        #{i["var"]} #{i["op"]} #{i["param"]}
      else
        #{i["var"]}
      end

      max = if #{i["var"]} > max do
        #{i["var"]}
      else
        max
      end

      """
    end
    |> Enum.join("")
  end
end

{:ok, txt} = File.read("8.txt")

instr =
  txt
  |> String.split("\n", trim: true)
  |> Enum.map(&Instructions.parse/1)

vars = Instructions.var_declaration(instr)

{_, values} = 
  instr
  |> Instructions.code_declaration()
  |> Code.eval_string(vars)
  |> IO.inspect

# values[:max]
# |> Enum.max_by(fn({_k, v}) -> v end)
# |> IO.inspect

