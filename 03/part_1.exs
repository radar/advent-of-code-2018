defmodule Part1 do
  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> List.flatten
    |> Enum.group_by(&(&1))
    |> Enum.filter(fn {_coord, list} ->
      list |> Enum.count >= 2
    end)
    |> Enum.map(fn {coord, _list} -> coord end)
  end

  def parse_line(line) do
    [_position, _at, origin, size] = line
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

    for x <- x_range, y <- y_range do
      {x, y}
    end
  end
end

case System.argv do
  ["--test"] ->
    ExUnit.start

    defmodule Part1Test do
      use ExUnit.Case

      test "parse_line" do
        coords = Part1.parse_line("""
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
        common = Part1.parse("""
        #1 @ 1,3: 4x4
        #2 @ 3,1: 4x4
        #3 @ 5,5: 2x2
        """)

        assert {3, 4} in common
        assert {3, 3} in common
        assert {4, 3} in common
        assert {4, 4} in common
      end

      test "input" do
        {:ok, contents} = File.read("input.txt")
        Part1.parse(contents) |> Enum.count |> IO.inspect
      end
    end
end
