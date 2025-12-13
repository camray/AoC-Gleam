import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type Range {
  Range(low: Int, high: Int)
}

pub fn part_1() {
  use file <- result.try(simplifile.read("input.txt"))
  let assert [in_ranges, products] = string.split(file, "\n\n")
  let ranges = process_ranges(in_ranges)
  products
  |> process_products(ranges)
  |> echo
  Ok(Nil)
}

pub fn process_ranges(input: String) -> List(Range) {
  input
  |> string.split("\n")
  |> list.map(fn(value) {
    let assert [low, high] =
      string.split(value, "-") |> list.filter_map(int.parse)
    Range(low:, high:)
  })
}

pub fn process_products(input: String, ranges: List(Range)) -> Int {
  input
  |> string.split("\n")
  |> list.filter_map(int.parse)
  |> list.count(fn(id) {
    list.any(ranges, fn(range) { range.low <= id && range.high >= id })
  })
}
