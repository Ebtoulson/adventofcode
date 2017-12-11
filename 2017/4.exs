defmodule Passphrase do
  def valid?(phrase) do
    words =
      phrase
      |> String.split(" ")

    duplicates?(words) && anagrams?(words)
  end

  def duplicates?(words) do
    words
    |> Enum.reduce(%{}, &build_presences/2)
    |> all_true?
  end

  def anagrams?(words) do
    words
    |> Enum.map(fn(word) ->
      word
      |> String.split("", trim: true)
      |> Enum.sort
      |> Enum.join
    end)
    |> Enum.reduce(%{}, &build_presences/2)
    |> all_true?
  end

  defp build_presences(word, dict) do
    case Map.has_key?(dict, word) do
      false -> Map.put(dict, word, true)
      true  -> Map.update!(dict, word, fn(_) -> false end)
    end
  end

  defp all_true?(presence_dict) do
    Enum.all?(presence_dict, fn({_k, v}) -> v end)
  end
end


defmodule Part1 do
  def solve(txt) do
    txt
    |> String.split("\n", trim: true)
    |> Enum.map(&Passphrase.valid?/1)
    |> Enum.count(&(&1))
  end
end

{:ok, txt} = File.read("4.txt")

Part1.solve(txt)
|> IO.puts
