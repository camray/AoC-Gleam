import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_2() -> Result(Nil, Nil) {
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
        Ok(val) -> val + process_ranges(rest)
        Error(_) -> {
          io.print_error("Error processing range: " <> range)
          process_ranges(rest)
        }
      }
    }
    [] -> {
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
  let length = string.length(item) / 2
  case string.length(item) > 1 {
    True -> is_invalid_at_starting_length(item, length)
    False -> False
  }
}

pub fn is_invalid_at_starting_length(item: String, length: Int) -> Bool {
  let chunks = chunk_string(item, length)
  let is_invalid = all_chunks_are_equal(chunks)

  case is_invalid {
    True -> True
    False -> {
      case length > 1 {
        True -> is_invalid_at_starting_length(item, length - 1)
        False -> False
      }
    }
  }
}

pub fn all_chunks_are_equal(items: List(String)) {
  case items {
    [a, b, ..rest] -> {
      case a == b {
        True -> all_chunks_are_equal([b, ..rest])
        False -> False
      }
    }
    [_a] -> True
    [] -> True
  }
}

pub fn chunk_string(item: String, chunk_size: Int) -> List(String) {
  case string.length(item) == 0 {
    True -> []
    False -> {
      case chunk_size > string.length(item) {
        True -> [item]
        False -> {
          let slice = string.slice(item, 0, chunk_size)
          let rest = string.slice(item, chunk_size, string.length(item))
          [slice, ..chunk_string(rest, chunk_size)]
        }
      }
    }
  }
}


pub fn sum_list(range: List(Int)) -> Int {
  list.fold(range, 0, fn(aggregator, value) { aggregator + value })
}
