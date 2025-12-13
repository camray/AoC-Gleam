import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type Range {
  Range(low: Int, high: Int)
}

pub fn part_2() {
  use file <- result.try(simplifile.read("input.txt"))
  let assert [in_ranges, _] = string.split(file, "\n\n")
  in_ranges
  |> process_ranges()
  |> combine_overlapping_ranges()
  |> count_ranges_values()
  |> echo

  Ok(Nil)
}

pub fn count_ranges_values(ranges: List(Range)) -> Int {
  use accumulator, range <- list.fold(ranges, 0)
  range.high - range.low + 1 + accumulator
}

pub fn process_ranges(input: String) -> List(Range) {
  use value <- list.map(string.split(input, "\n"))
  let assert [low, high] =
    string.split(value, "-") |> list.filter_map(int.parse)

  Range(low:, high:)
}

pub fn combine_overlapping_ranges(ranges: List(Range)) -> List(Range) {
  use accumulator, item <- list.fold(ranges, [])
  let #(overlapping, rest) = list.partition(accumulator, overlaps(_, item))
  [combine_ranges([item, ..overlapping]), ..rest]
}

pub fn overlaps(a: Range, b: Range) -> Bool {
  a.low <= b.high + 1 && b.low <= a.high + 1
}

pub fn combine_ranges(ranges: List(Range)) -> Range {
  let assert [first, ..rest] = ranges
  list.fold(rest, first, fn(acc, range) {
    Range(high: int.max(acc.high, range.high), low: int.min(acc.low, range.low))
  })
}
