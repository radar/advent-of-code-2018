defmodule Part1 do
  def parse(input) do
    counts = input
    |> Enum.map(&counts/1)

    twos = counts |> checksum(2)
    threes = counts |> checksum(3)

    twos * threes
  end

  def counts(box_id) do
    chars = box_id
    |> String.split("", trim: true)
    |> Enum.group_by(&(&1))
    |> Enum.map(fn ({char, list}) -> {char, list |> Enum.count} end)
    |> Enum.into(%{})
  end

  def checksum(counts, num) do
    counts |> Enum.count(fn (count) ->
      count |> Map.values |> Enum.any?(fn (x) -> x == num end)
    end)
  end
end


with {:ok, contents} <- File.read("input.txt") do
  contents |> String.split("\n", trim: true) |> Part1.parse |> IO.puts
end
