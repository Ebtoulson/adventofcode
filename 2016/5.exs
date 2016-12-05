defmodule Crypto do
  def md5(data) do
    Base.encode16(:erlang.md5(data), case: :lower)
  end
end

defmodule Hackers do
  def find_next(i \\ 0, room_id) do
    hash = Crypto.md5("#{room_id}#{i}")

    if valid?(hash) do
      {i, String.at(hash, 5), String.at(hash, 6)}
    else
      find_next(i+1, room_id)
    end
  end

  def valid?(hash) do
    hash
    |> String.starts_with?("00000")
  end
end


# index = 0
# for _ <- 1..2 do
#   {i, v} = Hackers.find_next(index, "abc")
#   index = i
#   IO.inspect([index, v])
# end

defmodule Acc1 do
  def take(number, confirmed_keys, _, _) when number <= 0, do: IO.inspect(Enum.join(confirmed_keys))
  def take(number, confirmed_keys, index, val) when number > 0 do
    {i, confirmed_key, _} = Hackers.find_next(index, val)
    take(number - 1, Enum.into([confirmed_key], confirmed_keys), i + 1, val)
  end
end

defmodule Acc2 do
  def take(number, confirmed_keys, _, _) when number <= 0 do
    confirmed_keys
    |> Enum.sort_by(fn({_, position}) -> String.to_integer(position) end)
    |> Enum.map(fn({key, _}) -> key end)
    |> Enum.join
    |> IO.puts
  end
  def take(number, confirmed_keys, index, val) when number > 0 do
    {i, position, confirmed_key} = Hackers.find_next(index, val)

    if valid_position?(position, confirmed_keys) do
      keys = Enum.into([{confirmed_key, position}], confirmed_keys)
      take(number - 1, keys, i + 1, val)
    else
      take(number, confirmed_keys, i + 1, val)
    end
  end

  defp valid_position?(position, confirmed_keys) do
    # please forgive me elixir gods
    case Integer.parse(position) do
      {intVal, _} ->
        if (intVal < 8) do
          dup = Enum.find(confirmed_keys, fn({_, p}) -> intVal == String.to_integer(p) end)
          if dup do
            false
          else
            true
          end
        else
          false
        end
      :error -> false
    end
  end
end


# Acc1.take(8, [], 0, "uqwqemis")
Acc2.take(8, [], 0, "uqwqemis")