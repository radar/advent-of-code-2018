defmodule Part2 do
  def parse(input) do
    input
    |> Enum.map(fn (box_id) ->
      input |> Enum.map(fn (box_id_2) -> {box_id, box_id_2, hamming_distance(box_id, box_id_2)} end)
    end)
    |> List.flatten
    |> Enum.filter(fn ({box_id_1, box_id_2, c}) -> c == 1 end)
  end

  def hamming_distance(strand1, strand2) when is_binary(strand1) and is_binary(strand2) do
    hamming_distance(strand1 |> split, strand2 |> split, 0)
  end

  def hamming_distance([h1|t1], [h2|t2], acc) do
    acc = if h1 != h2, do: acc + 1, else: acc
    hamming_distance(t1, t2, acc)
  end

  def hamming_distance(_, _, acc) do
    acc
  end

  defp split(string), do: string |> String.split("", trim: true)
end


with {:ok, contents} <- File.read("input.txt") do
  contents |> String.split("\n", trim: true) |> Part2.parse |> IO.inspect
end
