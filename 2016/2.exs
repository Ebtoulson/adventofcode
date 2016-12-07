defmodule Keypad do

  def calculate(nil, sequence), do: calculate(5, sequence)
  def calculate(current_button, sequence) do
    sequence
    |> Enum.reduce(current_button, fn(x, acc) -> next(acc, x) end)
  end

  defp next(current_button, direction) do
    move_direction(direction).(current_button)
  end

  defp move_direction(direction) do
    case direction do
      "R" -> (fn(current_button) -> if rem(current_button, 3) == 0, do: current_button, else: current_button + 1 end)
      "L" -> (fn(current_button) -> if rem(current_button, 3) == 1, do: current_button, else: current_button - 1 end)
      "U" -> (fn(current_button) -> unless current_button > 3,      do: current_button, else: current_button - 3 end)
      "D" -> (fn(current_button) -> unless current_button < 7,      do: current_button, else: current_button + 3 end)
    end
  end
end


{:ok, txt} = File.read("2.txt")

txt = 
  txt
  |> String.split("\n")
  |> Enum.map(&String.graphemes/1)


# txt
# |> Enum.reduce([], fn(seq, known_buttons) ->
#     Enum.into(
#       [Keypad.calculate(List.last(known_buttons), seq)],
#       known_buttons
#     )
#   end)
# |> Enum.join("")
# |> IO.inspect


defmodule StarKeypad do
  @grid [
    [nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, "1", nil, nil, nil],
    [nil, nil, "2", "3", "4", nil, nil],
    [nil, "5", "6", "7", "8", "9", nil],
    [nil, nil, "A", "B", "C", nil, nil],
    [nil, nil, nil, "D", nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil]
  ]

  @directions %{
    "R" => {0, 1},
    "L" => {0, -1},
    "U" => {-1, 0},
    "D" => {1, 0}
  }

  def calculate(nil, sequence), do: calculate({3, 1}, sequence)
  def calculate(current_button, sequence) do
    sequence
    |> Enum.reduce(current_button, fn(x, acc) -> next(acc, x) end)
  end

  def coords_to_letter({y, x}) do
    @grid |> Enum.at(y) |> Enum.at(x)
  end

  defp next(current_button, direction) do
    {y, x} = current_button

    {y2, x2} = Map.get(@directions, direction, {0, 0})

    new_x = x + x2
    new_y = y + y2

    valid? = coords_to_letter({new_y, new_x})

    if valid? do
      IO.inspect([direction, "valid", coords_to_letter({new_y, new_x})])
      {new_y, new_x}
    else
      IO.inspect([direction, "invalid", coords_to_letter({y, x})])
      {y, x}
    end
  end
end


txt
|> Enum.reduce([], fn(seq, known_buttons) ->
    Enum.into(
      [StarKeypad.calculate(List.last(known_buttons), seq)],
      known_buttons
    )
  end)
|> Enum.map(fn(coord) -> StarKeypad.coords_to_letter(coord) end)
|> Enum.join("")
|> IO.inspect