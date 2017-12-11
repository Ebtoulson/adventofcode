defmodule Garbage do
  def parse(str) do
    str
    |> remove_ignored_characters()
    |> remove_garbage()
    |> count_groups()
  end

  defp remove_ignored_characters(str) do
    String.replace(str, ~r/(\!(\!\!)*.{1})/, "")
  end

  defp remove_garbage(str) do
    String.replace(str, ~r/(<.*?>)/, "")
  end

  def count_garbage(str) do
    without_ignored =
      remove_ignored_characters(str)

    ~r/(<.*?>)/
    |> Regex.scan(without_ignored)
    |> Enum.map(&((List.first(&1) |> String.length()) - 2))
    |> Enum.sum
  end

  defp count_groups(str) when is_binary(str) do
    String.to_charlist(str)
    |> count_groups()
  end
  defp count_groups(str) do
    [h | t] = str
    calculate_score(h, t, {0, []})
    |> Enum.sum
  end

  defp calculate_score(?{, [h | t], {score, scores}) do
    score = score + 1
    calculate_score(h, t, {score, scores ++ [score]})
  end
  defp calculate_score(?}, [h | t], {score, scores}) do
    calculate_score(h, t, {score - 1, scores})
  end
  defp calculate_score(_, [h | t], score_acc) do
    calculate_score(h, t, score_acc)
  end
  defp calculate_score(_, [], {_score, scores}), do: scores
end


[
  "{}",
  "{{{}}}",
  "{{},{}}",
  "{{{},{},{{}}}}", 
  "{<{},{},{{}}>}",
  "{<a>,<a>,<a>,<a>}",
  "{{<ab>},{<ab>},{<ab>},{<ab>}",
  "{{<!!>},{<!!>},{<!!>},{<!!>}}",
  "{{<a!>},{<a!>},{<a!>},{<ab>}}"
]
|> Enum.map(&Garbage.parse/1)

{:ok, txt} = File.read("9.txt")
Garbage.parse(txt)


[
  "<>",
  "<random characters>",
  "<<<<>",
  "<{!>}>",
  "<!!>",
  "<!!!>>",
  "<{o\"i!a,<{i<a>"
]
|> Enum.map(&Garbage.count_garbage/1)

IO.inspect Garbage.count_garbage(txt)
