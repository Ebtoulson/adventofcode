defmodule FileParser do
  def read(file \\ "02.txt") do
    file
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Intcode do
  def run(ints, starting_index \\ 0) do
    op   = Enum.at(ints, starting_index)
    pos1 = Enum.at(ints, starting_index + 1)
    pos2 = Enum.at(ints, starting_index + 2)
    result_pos = Enum.at(ints, starting_index + 3)

    case opcode(op) do
      :halt -> ints
      :cont ->
        val1 = Enum.at(ints, pos1)
        val2 = Enum.at(ints, pos2)

        ints
        |> List.replace_at(result_pos, op(op).(val1, val2))
        |> run(starting_index + 4)
    end
  end

  def opcode(1), do: :cont
  def opcode(2), do: :cont
  def opcode(99), do: :halt

  def op(1), do: &Kernel.+/2
  def op(2), do:  &Kernel.*/2

  def update_noun_verb(ints, noun, verb) do
    ints
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end
end

ExUnit.start()

defmodule AssertionTest do
  use ExUnit.Case, async: true

  test "examples" do
    assert Intcode.run([1,0,0,0,99]) == [2,0,0,0,99]
    assert Intcode.run([2,3,0,3,99]) == [2,3,0,6,99]
    assert Intcode.run([2,4,4,5,99,0]) == [2,4,4,5,99,9801]
    assert Intcode.run([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]
  end
end

# FileParser.read()
#|> Intcode.update_noun_verb(12, 2)
# |> Intcode.run()
# |> IO.inspect()


for noun <- 0..99, verb <- 0..99 do
  case FileParser.read()
       |> Intcode.update_noun_verb(noun, verb)
       |> Intcode.run()
       |> List.first() do

    19690720 -> (100 * noun + verb) |> IO.puts()
    _ -> :ok
  end
end