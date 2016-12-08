{:ok, txt} = File.read("4.txt")

defmodule Room do
  def parse(raw_line) do
    [_, encrypted_name, section_id, checksum] = Regex.run(~r/([^\d]+)-(\d+)\[(\w+)\]/, raw_line)
    [encrypted_name, String.to_integer(section_id), checksum]
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
    calculated_checksum =
      encrypted_name
      |> String.replace("-", "")
      |> calculate_checksum

    calculated_checksum == checksum
  end

  def shift_cipher(str, num) do
    str
    |> to_charlist
    |> Enum.map(fn(char) -> shift(char, num) end)
    |> Enum.join
  end

  defp shift(45, _), do: ' '
  defp shift(char, num) do
    num = 
      cond do
        num > 26 -> rem(num, 26)
        true -> num
      end

    bit = 
      cond do
        (char + num) > 122 -> char + num - 122 + 96
        true -> char + num
      end

    bit |> List.wrap |> to_string
  end
end

txt
|> String.split("\n")
|> Enum.map(&Room.parse/1)
|> Enum.map(fn([name, id, checksum]) -> [name, Room.real?([name, checksum]), id] end)
|> Enum.filter(fn([_, real, _]) -> real end)
|> Enum.map(fn([name, _, id]) -> [Room.shift_cipher(name, id), id] end)
|> IO.inspect(limit: :infinity)
