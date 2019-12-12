# However, they do remember a few key facts about the password:

# It is a six-digit number.
# The value is within the range given in your puzzle input.
# Two adjacent digits are the same (like 22 in 122345).
# Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
# Other than the range rule, the following are true:

# 111111 meets these criteria (double 11, never decreases).
# 223450 does not meet these criteria (decreasing pair of digits 50).
# 123789 does not meet these criteria (no double).
# How many different passwords within the range given in your puzzle input meet these criteria?

defmodule Password do
  def potential(range) do
    Enum.filter(range, &valid/1)
  end

  def valid(pw) do
    with true <- six_digits(pw),
         true <- has_double(pw),
         true <- decreasing(pw) do
      true
    else
      _ -> false
    end
  end

  def six_digits(pw), do: Enum.count(to_charlist(pw)) == 6

  def has_double(pw) do
    pw
    |> to_charlist()
    |> Enum.chunk_by(& &1)
    |> Enum.any?(&(Enum.count(&1) == 2))
  end

  def decreasing(pw) do
    passing =
      pw
      |> to_charlist()
      |> Enum.map(fn(i)-> String.to_integer(to_string(i)) end)
      |> Enum.reduce_while(0, fn(c, acc) ->
        case c >= acc do
          true -> {:cont, c}
          false -> {:halt, false}
        end
      end)

      !!passing
  end
end

ExUnit.start()

defmodule AssertionTest do
  use ExUnit.Case, async: true

  test "part 1 examples" do
    # assert Password.valid("111111") == true
    assert Password.valid("223450") == false
    assert Password.valid("123789") == false
    assert Password.valid("112233") == true
    assert Password.valid("123444") == false
    assert Password.valid("111122") == true
  end
end

Password.potential(372037..905157)
|> Enum.count()
|> IO.inspect()