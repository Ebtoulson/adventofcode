defmodule FileParser do
  def read(file \\ "05.txt") do
    file
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Intcode do
  defstruct [
    :input,
    :next_index,
    :opcode,
    :params,
    :result_pos,
    :starting_index
  ]

  def run(ints, input \\ 1, starting_index \\ 0) do
    intcode = parse_program(input, ints, starting_index)

    case opcode(intcode.opcode) do
      :halt -> ints
      :cont ->
        {ints, intcode} =
          case op_fn(intcode) do
            {:val, val} ->
              {List.replace_at(ints, intcode.result_pos, val), intcode}

            {:output, output} ->
              IO.puts("Output: #{output}")
              {ints, intcode}

            {:pointer, pointer} ->
              {ints, %{intcode | next_index: pointer}}


            _ -> {ints, intcode}
          end

        run(ints, input, intcode.next_index)
    end
  end

  def opcode(99), do: :halt
  def opcode(_), do: :cont

  def op_fn(%{opcode: 1} = intcode), do: {:val, apply(&Kernel.+/2, intcode.params)}
  def op_fn(%{opcode: 2} = intcode), do: {:val, apply(&Kernel.*/2, intcode.params)}
  def op_fn(%{opcode: 4, params: [first | _rest]}), do: {:output, first}

  def op_fn(%{opcode: 3}) do
    input =
      "Input (single digit)?"
      |> IO.gets()
      |> String.trim()
      |> String.to_integer()

    {:val, input}
  end

  def op_fn(%{opcode: 5, params: [first, second | _rest]}) do
    if first == 0 do
      :skip
    else
      {:pointer, second}
    end
  end

  def op_fn(%{opcode: 6, params: [first, second | _rest]}) do
    if first == 0 do
      {:pointer, second}
    else
      :skip
    end
  end

  def op_fn(%{opcode: 7, params: [first, second | _rest]}) do
    if first < second do
      {:val, 1}
    else
      {:val, 0}
    end
  end

  def op_fn(%{opcode: 8, params: [first, second | _rest]}) do
    if first == second do
      {:val, 1}
    else
      {:val, 0}
    end
  end

  def op_param_count(1), do: 2
  def op_param_count(2), do: 2
  def op_param_count(3), do: 0
  def op_param_count(4), do: 1
  def op_param_count(5), do: 2
  def op_param_count(6), do: 2
  def op_param_count(7), do: 2
  def op_param_count(8), do: 2
  def op_param_count(99), do: 0

  def has_ouput_param(99), do: 0
  def has_ouput_param(4), do: 0
  def has_ouput_param(5), do: 0
  def has_ouput_param(6), do: 0
  def has_ouput_param(_), do: 1

  def parameter_mode(0, ints, param), do: get_at(ints, param)
  def parameter_mode(1, _ints, param), do: param

  def parse_program(input, ints, starting_index) do
    {mode_params, op} =
      ints
      |> get_at(starting_index)
      |> to_string()
      |> String.split_at(-2)

    opcode = String.to_integer(op)
    param_count = op_param_count(opcode)
    next_index = starting_index + 1 + param_count + has_ouput_param(opcode)

    modes =
      mode_params
      |> String.codepoints()
      |> Enum.reverse()
      |> Enum.map(&String.to_integer/1)
      |> Kernel.++(List.duplicate(0, 3)) # ensure zip defaults to 0

    params =
      ints
      |> list_slice((starting_index + 1), param_count)
      |> Enum.zip(modes)
      |> Enum.map(fn({param_num, mode}) ->
        parameter_mode(mode, ints, param_num)
      end)

    result_pos =
      case has_ouput_param(opcode) do
        1 -> Enum.at(ints, next_index - 1)
        _ -> nil
      end

    %Intcode{
      input: input,
      opcode: opcode,
      starting_index: starting_index,
      params: params,
      result_pos: result_pos,
      next_index: next_index
    }
  end

  def update_noun_verb(ints, noun, verb) do
    ints
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  def get_at(list, index), do: Enum.at(list, index)

  defp list_slice(list, start, len) do
    {_, rest} = Enum.split(list, start)

    Enum.take(rest, len)
  end
end

FileParser.read()
|> Intcode.run()