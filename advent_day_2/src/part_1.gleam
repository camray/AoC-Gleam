import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_1() -> Result(Nil, Nil) {
  io.println("Hello from advent_day_2!")
  use file <- result.try(read_file("input.txt"))
  let id_ranges = split_file_into_id_ranges(file)
  echo process_ranges(id_ranges)

  Ok(Nil)
}

pub fn read_file(path: String) -> Result(String, Nil) {
  case simplifile.read(path) {
    Ok(file) -> {
      Ok(file)
    }
    Error(_err) -> {
      io.print_error("Unable to read file: " <> path)
      Error(Nil)
    }
  }
}

pub fn split_file_into_id_ranges(file: String) -> List(String) {
  string.split(file, ",")
}

pub fn process_ranges(ranges: List(String)) -> Int {
  case ranges {
    [range, ..rest] -> {
      case process_range(range) {
        Ok(val) -> process_ranges(rest) + val
        Error(_) -> {
          io.print_error("Error processing range: " <> range)
          process_ranges(rest)
        }
      }
    }
    [] -> {
      io.println("Base case")
      0
    }
  }
}

pub fn process_range(range: String) -> Result(Int, Nil) {
  case string.split(range, "-") {
    [bottom_str, top_str] -> {
      let bottom = int.parse(bottom_str)
      let top = int.parse(top_str)

      case bottom, top {
        Ok(bottom), Ok(top) -> {
          let int_range = list.range(bottom, top)
          let result =
            int_range
            |> find_invalid_in_range
            |> sum_list
          Ok(result)
        }
        _, _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

pub fn find_invalid_in_range(range: List(Int)) -> List(Int) {
  list.filter(range, is_invalid)
}

pub fn is_invalid(item: Int) -> Bool {
  let item = int.to_string(item)
  let length = string.length(item)
  let length_is_even = length % 2 == 0
  case length_is_even && length > 0 {
    False -> False
    True -> {
      let #(a, b) = split_even(item)
      a == b
    }
  }
}

pub fn split_even(s: String) -> #(String, String) {
  let len = string.length(s)
  let mid = len / 2
  let left = string.slice(s, 0, mid)
  let right = string.slice(s, mid, len)
  #(left, right)
}

pub fn sum_list(range: List(Int)) -> Int {
  list.fold(range, 0, fn(aggregator, value) { aggregator + value })
}
