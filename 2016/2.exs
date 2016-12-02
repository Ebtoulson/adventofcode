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

txt
|> String.split("\n")
|> Enum.map(&String.graphemes/1)
|> Enum.reduce([], fn(seq, known_buttons) ->
    Enum.into(
      [Keypad.calculate(List.last(known_buttons), seq)],
      known_buttons
    )
  end)
|> Enum.join("")
|> IO.inspect