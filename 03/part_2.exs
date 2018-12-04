defmodule Part2 do
  # TODO: Extremely inefficient. Find a way to refactor this!
  def parse(input) do
    claims = input
    |> String.splitter("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> List.flatten

    single_claims = claims
    |> aggregate_claims(%{})
    |> Enum.filter(fn ({_coord, claims}) -> claims |> Enum.count == 1 end)
    |> Enum.into(%{})

    {intact_position, _coords} = claims |> Enum.filter(fn {position, coords} ->
      position
      Enum.filter(single_claims, fn {coord, positions} -> position in positions end)
      |> Enum.count == coords |> Enum.count
    end)
    |> List.first

    intact_position
  end

  def aggregate_claims([], claims) do
    claims
  end

  def aggregate_claims([{position, coords} | rest], claims) do
    claims = coords
    |> Enum.reduce(claims, fn (coord, all_claims) ->
      all_claims
      |> Map.put_new(coord, [])
      |> Map.update(coord, [], fn (current_claims) ->
          [position | current_claims]
         end)
    end)

    aggregate_claims(rest, claims)
  end

  def parse_line(line) do
    [position, _at, origin, size] = line
    |> String.trim
    |> String.split(" ")

    [start_x, start_y] = origin
    |> String.slice(0..-2)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    [size_x, size_y] = size
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)

    x_range = start_x .. start_x + size_x - 1
    y_range = start_y .. start_y + size_y - 1

    coords = for x <- x_range, y <- y_range do
      {x, y}
    end
    {position, coords}
  end
end

case System.argv do
  ["--test"] ->
    ExUnit.start

    defmodule Part1Test do
      use ExUnit.Case
      @moduletag timeout: 120000

      test "parse_line" do
        {position, coords} = Part2.parse_line("""
        #123 @ 3,2: 5x4
        """)

        assert {3, 2} in coords
        assert {4, 2} in coords
        assert {5, 2} in coords
        assert {6, 2} in coords
        assert {7, 2} in coords

        assert {3, 3} in coords
        assert {4, 3} in coords
        assert {5, 3} in coords
        assert {6, 3} in coords
        assert {7, 3} in coords

        assert {3, 4} in coords
        assert {4, 4} in coords
        assert {5, 4} in coords
        assert {6, 4} in coords
        assert {7, 4} in coords

        assert {3, 5} in coords
        assert {4, 5} in coords
        assert {5, 5} in coords
        assert {6, 5} in coords
        assert {7, 5} in coords
      end

      test "parse" do
        intact = Part2.parse("""
        #1 @ 1,3: 4x4
        #2 @ 3,1: 4x4
        #3 @ 5,5: 2x2
        """)

        assert intact == "#3"
      end

      test "input" do
        {:ok, contents} = File.read("input.txt")
        Part2.parse(contents) |> IO.inspect
      end
    end
end
