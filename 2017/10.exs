defmodule KnotCrypto do
  def tie(list, lengths) do
    Enum.reduce(lengths, [0, 0, list], fn(len, acc) ->
      [current_position, skip_size, list] = acc

      [
        next_position(list, current_position + skip_size + len),
        skip_size + 1,
        slice_at(list, current_position, len)
      ]
    end)
  end

  def slice_at(list, position, len) do
    size = Enum.count(list)
    slice_to = position + (len - 1)

    unwrapped_list = Enum.slice(list, position..slice_to)
    {end_untouched, wrapped_list} = wrapped(list, size, slice_to, len)

    sliced =
      unwrapped_list
      |> Kernel.++(wrapped_list)
      |> Enum.reverse

    {u, w} = Enum.split(sliced, Enum.count(unwrapped_list))
    front_untouched = calc_front_untouched(list, position, wrapped_list)

    w ++ front_untouched ++ u ++ end_untouched

  end

  def next_position(list, next) do
    max = Enum.count(list)

    if next > max do
      next - max
    else
      next
    end
  end

  def calc_front_untouched(list, position, wrapped_list) do
    start = Enum.count(wrapped_list)

    if start == position do
      []
    else
      Enum.slice(list, start..(position - 1))
    end
  end


  # returns the end of the list that isnt sliced and the wrapped list
  def wrapped(list, size, slice_to, len) do
    leftover = size - slice_to

    if len > 0 and leftover <= 0 do
      w = 
        list
        |> Enum.slice(0..abs(leftover))
        |> Enum.to_list

      {[], w}
    else
      {Enum.slice(list, (slice_to + 1)..(size - 1)), []}
    end
  end
end

0..255
|> Enum.to_list
|> KnotCrypto.tie([88,88,211,106,141,1,78,254,2,111,77,255,90,0,54,205])
|> IO.inspect
