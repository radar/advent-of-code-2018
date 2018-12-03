defmodule Part2 do
  def parse(frequency, seen) do
    with {:ok, contents} <- File.read("input.txt") do
      contents
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> do_loop(frequency, seen)
    end
  end

  defp do_loop([], current, seen) do
    parse(current, seen)
  end

  defp do_loop([adjustment | rest], current, seen) do
    new_frequency = current + adjustment
    if MapSet.member?(seen, new_frequency) do
      IO.puts "First repeat: #{new_frequency}"
    else
      do_loop(rest, new_frequency, MapSet.put(seen, new_frequency))
    end
  end
end


Part2.parse(0, MapSet.new([]))
