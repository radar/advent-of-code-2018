defmodule Part1 do
  def sort(lines), do: lines |> Enum.sort

  def chunk(times), do: chunk(times, [])

  def chunk([], guards) do
    guards |> Enum.reverse
  end

  def chunk([shift_start | remainder], guards) do
    {this_guard, rest} = remainder
    |> Enum.split_while(fn (line) ->
      !String.contains?(line, "begins shift")
    end)
    this_guard = [shift_start | this_guard]
    chunk(rest, [this_guard | guards])
  end
end

case System.argv do
  ["--test"] ->
    ExUnit.start

    defmodule Part1Test do
      use ExUnit.Case

      test "sort" do
        input = """
          [1518-09-22 23:50] Guard #2309 begins shift
          [1518-06-26 00:42] falls asleep
        """
        |> String.split("\n", trim: true)
        |> Enum.map(&String.trim/1)

        actual = Part1.sort(input)

        assert actual == [
          "[1518-06-26 00:42] falls asleep",
          "[1518-09-22 23:50] Guard #2309 begins shift"
        ]
      end

      test "chunking" do
        input = """
        [1518-11-01 00:00] Guard #10 begins shift
        [1518-11-01 00:05] falls asleep
        [1518-11-01 00:25] wakes up
        [1518-11-01 00:30] falls asleep
        [1518-11-01 00:55] wakes up
        [1518-11-01 23:58] Guard #99 begins shift
        [1518-11-02 00:40] falls asleep
        [1518-11-02 00:50] wakes up
        """
        |> String.split("\n", trim: true)
        |> Enum.map(&String.trim/1)

        [first_chunk, second_chunk] = Part1.chunk(input)


        assert first_chunk == [
          "[1518-11-01 00:00] Guard #10 begins shift",
          "[1518-11-01 00:05] falls asleep",
          "[1518-11-01 00:25] wakes up",
          "[1518-11-01 00:30] falls asleep",
          "[1518-11-01 00:55] wakes up",
        ]

        assert second_chunk == [
          "[1518-11-01 23:58] Guard #99 begins shift",
          "[1518-11-02 00:40] falls asleep",
          "[1518-11-02 00:50] wakes up",
        ]
      end
    end
end
