import file_streams/file_stream
import gleam/bit_array
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type RunningResult {
  RunningResult(location: Int, zero_hits: Int)
}

pub fn day_1_part_1() -> Result(Nil, Nil) {
  let file_name = "input.txt"
  let starting_point = 50

  use stream <- result.try(ignore_error(file_stream.open_read(file_name)))
  use output_bits <- result.try(
    ignore_error(file_stream.read_remaining_bytes(stream)),
  )
  use output <- result.try(bit_array.to_string(output_bits))
  let final =
    output
    |> string.split("\n")
    |> list.filter(fn(line) { line != "" })
    |> list.fold(
      RunningResult(location: starting_point, zero_hits: 0),
      process_line,
    )

  echo final

  Ok(Nil)
}

fn ignore_error(r: Result(a, _)) -> Result(a, Nil) {
  result.map_error(r, fn(_) { Nil })
}

fn process_line(running_result: RunningResult, line: String) -> RunningResult {
  let direction = string.slice(from: line, at_index: 0, length: 1)
  let value =
    line
    |> string.drop_start(1)
    |> int.parse
    |> result.unwrap(0)

  case direction {
    "R" -> add(running_result, value)
    "L" -> subtract(running_result, value)
    _ -> running_result
  }
}

pub fn subtract(running: RunningResult, value: Int) -> RunningResult {
  let location = { running.location - value } % 100

  let zero_hits = case location {
    0 -> running.zero_hits + 1
    _ -> running.zero_hits
  }

  RunningResult(location: location, zero_hits: zero_hits)
}

pub fn add(running: RunningResult, value: Int) -> RunningResult {
  let location = { running.location + value } % 100

  let zero_hits = case location {
    0 -> running.zero_hits + 1
    _ -> running.zero_hits
  }

  RunningResult(location: location, zero_hits: zero_hits)
}
