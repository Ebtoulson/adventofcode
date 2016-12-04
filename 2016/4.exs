{:ok, txt} = File.read("4.txt")

defmodule Room do
  def parse(raw_line) do
    [_, encrypted_name, section_id, checksum] = Regex.run(~r/([^\d]+)(\d+)\[(\w+)\]/, raw_line)
    [String.replace(encrypted_name, "-", ""), String.to_integer(section_id), checksum]
  end

  def calculate_checksum(encrypted_name) do
    encrypted_name
    |> String.graphemes
    |> Enum.filter(fn(x)-> String.match?(x, ~r/\w/) end)
    |> Enum.group_by(fn(x)-> x end)
    |> Enum.map(fn({k, v}) -> [k, Enum.count(v)] end)
    |> Enum.sort_by(fn([_, count]) -> -count end)
    |> Enum.map(fn([letter, _]) -> letter end)
    |> Enum.take(5)
    |> Enum.join
  end

  def real?([encrypted_name, checksum]) do
    calculate_checksum(encrypted_name) == checksum
  end
end

txt
|> String.split("\n")
|> Enum.map(&Room.parse/1)
|> Enum.map(fn([name, id, checksum]) -> [Room.real?([name, checksum]), id] end)
|> Enum.filter(fn([real, _]) -> real end)
|> Enum.reduce(0, fn([_, id], acc) -> acc + id end)
|> IO.inspect
