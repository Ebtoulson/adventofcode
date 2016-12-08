{:ok, raw} = File.read("7.txt")

ip_addresses =
  raw
  |> String.split("\n")


defmodule ABBA do
  def check(raw) do
    captures = Regex.scan(~r/\[([^\[]+)\]/, raw)

    not_allowed_captures = captures |> Enum.map(&List.last/1)
    not_allowed_matches = captures |> Enum.map(&List.first/1)

    allowed = raw |> String.split(not_allowed_matches)

    allowed? = allowed |> Enum.map(&abba?/1) |> Enum.any?
    disallowed? = not_allowed_captures |> Enum.map(&abba?/1) |> Enum.any?

    allowed? and not disallowed?
  end

  def abba?(str) do
    slice_size = 4
    charlist = str |> to_charlist
    length = charlist |> Enum.count
    groups = length - slice_size

    charlist
    |> slices(slice_size, groups)
    |> Enum.any?(fn(s) -> abba_check(s) end)
  end

  def abba_check(str) do
    [a, b, c, d] = to_charlist(str)

    (a != b) and (a == d) and (b == c)
  end

  def slices(str, size, index, collected \\ [])
  def slices(_str, _size, index, collected) when index < 0, do: collected
  def slices(str, size, index, collected) do
    collection =
      str
      |> Enum.slice(index, size)
      |> to_string
      |> List.wrap
      |> Enum.into(collected)

    slices(str, size, (index - 1), collection)
  end
end


ip_addresses
|> Enum.map(&ABBA.check/1)
|> Enum.filter(fn(x) -> x end)
|> Enum.count
|> IO.inspect


defmodule SSL do
  def check(raw) do
    captures = Regex.scan(~r/\[([^\[]+)\]/, raw)

    hypernet_captures = captures |> Enum.map(&List.last/1)
    hypernet_matches = captures |> Enum.map(&List.first/1)

    supernet = raw |> String.split(hypernet_matches)

    abas = supernet |> Enum.flat_map(&aba_or_bab_check/1)
    babs = hypernet_captures |> Enum.flat_map(&aba_or_bab_check/1)

    inverse_match?(abas, babs)
    |> Enum.any?
  end

  def aba_or_bab_check(str) do
    slice_size = 3
    charlist = str |> to_charlist
    length = charlist |> Enum.count
    groups = length - slice_size

    charlist
    |> slices(slice_size, groups)
    |> Enum.map(fn(s) -> aba_check(s) end)
    |> Enum.filter(fn(x) -> x end)
  end

  def aba_check(str) do
    [a, b, c] = to_charlist(str)

    if a == c and a != b do
      str
    else
      false
    end
  end

  def inverse_match?(aba_list, bab_list) do
    babs = aba_list
    |> Enum.map(fn(str) ->
      [a, b, a] = to_charlist(str)
      [b, a, b] |> to_string
    end)

    intersection(babs, bab_list)
  end

  def intersection(list1, list2) do
    (list1 -- (list1 -- list2))
  end

  def slices(str, size, index, collected \\ [])
  def slices(_str, _size, index, collected) when index < 0, do: collected
  def slices(str, size, index, collected) do
    collection =
      str
      |> Enum.slice(index, size)
      |> to_string
      |> List.wrap
      |> Enum.into(collected)

    slices(str, size, (index - 1), collection)
  end
end

ip_addresses
|> Enum.map(&SSL.check/1)
|> Enum.filter(fn(x) -> x end)
|> Enum.count
|> IO.inspect