with {:ok, contents} <- File.read("input.txt") do
  contents
  |> String.split("\n", trim: true)
  |> IO.inspect
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum
  |> IO.puts
end
