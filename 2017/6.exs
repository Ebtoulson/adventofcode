defmodule MemoryAllocator do
  def find_loop(blanks, previous_states \\ []) do
    new_state = allocate(blanks)
    if Enum.count(previous_states, fn(s) -> new_state == s end) > 1 do
      previous_states
      |> Enum.with_index
      |> Enum.filter(fn({s, _i}) -> s == new_state end)
      |> Enum.map(fn({_s, i}) -> i end)
      |> Enum.reduce(&Kernel.-/2)
    else
      find_loop(new_state, previous_states ++ [new_state])
    end
  end

  def allocate(blanks) do
    {blocks, index} =
      blanks
      |> Enum.with_index
      |> Enum.max_by(fn({v, _i}) -> v end)

    allocation_offset = offset(blanks, blocks, index)
    blanks = List.replace_at(blanks, index, 0)

    reduce_sum_lists([blanks, allocation_offset])
  end

  def offset(blanks, blocks, current_index) do
    blank_size = Enum.count(blanks)

    [List.duplicate(0, (current_index + 1)),
     List.duplicate(1, blocks)]
    |> List.flatten()
    |> Enum.chunk_every(blank_size, blank_size, Stream.cycle([0]))
    |> reduce_sum_lists()
  end

  def reduce_sum_lists(lists) do
    lists
    |> Enum.zip
    |> Enum.map(&( &1 |> Tuple.to_list |> Enum.sum ))
  end
end

# "2 4 1 2"
"4 1 15  12  0 9 9 5 5 8 7 3 14  5 12  3"
|> String.split(" ", trim: true)
|> Enum.map(&String.to_integer/1)
|> MemoryAllocator.find_loop()
|> IO.inspect
