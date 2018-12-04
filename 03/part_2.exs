defmodule Part2 do
  # TODO: Extremely inefficient. Find a way to refactor this!
  def parse(input) do
    claims = input
    |> String.splitter("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> List.flatten

    [claim] = Enum.filter(claims, fn (claim) ->
      !Enum.any?(claims, &(intersects?(&1, claim)))
    end)

    {claim_id, _, _, _, _} = claim
    claim_id
  end

  def intersects?({claim_1, _, _, _, _}, {claim_2, _, _, _, _}) when claim_1 == claim_2, do: false

  def intersects?(
    {_claim_1, start_x_1, start_y_1, width_1, height_1},
    {_claim_2, start_x_2, start_y_2, width_2, height_2}
  ) do

    left_x = Enum.max([start_x_1, start_x_2])
    right_x = Enum.min([start_x_1 + width_1, start_x_2 + width_2])

    top_y = Enum.max([start_y_1, start_y_2])
    bottom_y = Enum.min([start_y_1 + height_1, start_y_2 + height_2])

    left_x < right_x && top_y < bottom_y
  end

# ........
# ...2222.
# ...2222.
# .11XX22.
# .11XX22.
# .111133.
# .111133.
# ........

  def parse_line(line) do
    [position, _at, origin, size] = line
    |> String.trim
    |> String.split(" ")

    [start_x, start_y] = origin
    |> String.slice(0..-2)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    [width, height] = size
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)

    {position, start_x, start_y, width, height}
  end
end

case System.argv do
  ["--test"] ->
    ExUnit.start

    defmodule Part1Test do
      use ExUnit.Case
      @moduletag timeout: 120000

      test "parse_line" do
        {position, start_x, start_y, width, height} = Part2.parse_line("""
        #123 @ 3,2: 5x4
        """)

        assert position == "#123"
        assert start_x == 3
        assert start_y == 2
        assert width == 5
        assert height == 4
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
