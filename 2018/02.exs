# the number that have an ID containing:
# - exactly two of any letter
# - separately counting those with exactly three of any letter.
# - You can multiply those two counts together to get a rudimentary checksum

defmodule Boxes do
	def parse() do
		"02.txt"
		|> File.read!()
		|> String.split("\n")
	end

	def checksum(ids) do
		{twos, threes} =
			Enum.reduce(ids, {0, 0}, fn(id, {two, three}) ->
				counts =
					id
					|> char_counts()
					|> IO.inspect()
					# |> Enum.each(fn(cc)-> IO.inspect(cc) end)
					|> Enum.reduce({0, 0}, fn(cc, {c, d})->
						{e, f} = matches(cc)
						{c + e, d + f}
					end)
				IO.inspect(counts)
				{a, b} = ensure_one_match(counts)
				IO.inspect({a, b})
				IO.puts("-----")
				{two + a, three + b}
			end)

		twos * threes
	end

	# def checksum(id) do
	# 	:md5
	# 	|> :crypto.hash(id)
	# 	|> Base.encode16()
	# end

	defp char_counts(id) do
		id
		|> String.codepoints()
		|> Enum.group_by(&(&1))
		|> Enum.map(fn({k, v}) -> {k, Enum.count(v)} end)
	end

	defp matches({_, 2}), do: {1, 0}
	defp matches({_, 3}), do: {0, 1}
	defp matches(_), do: {0, 0}

	defp ensure_one_match({a, b}) when a > 1 and b > 1, do: {1, 1}
	defp ensure_one_match({a, b}) when a > 1, do: {1, b}
	defp ensure_one_match({a, b}) when b > 1, do: {a, 1}
	defp ensure_one_match({a, b}), do: {a, b}

	def get_close_distances(ids) do
    Enum.reduce(ids, [], fn(id, acc)-> 
      distance =
        ids
        |> Enum.map(&(String.jaro_distance(id, &1)))
        |> Enum.max_by(fn(x)->
        	case x do
        		1.0 -> 0
        		_ -> x
        	end
        end)

      [{id, distance} | acc]

    end)
    |> Enum.sort_by(fn({id, val})-> val end)
    |> Enum.take(-2)
  end

end

Boxes.parse()
# |> Boxes.checksum()
|> Boxes.get_close_distances()
|> IO.inspect