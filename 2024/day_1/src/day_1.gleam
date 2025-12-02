import file_streams/file_stream
import gleam/bit_array
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn main() -> Result(Nil, Nil) {
  let file_name = "input.txt"
  use stream <- result.try(ignore_error(file_stream.open_read(file_name)))
  use output_bits <- result.try(
    ignore_error(file_stream.read_remaining_bytes(stream)),
  )
  use output <- result.try(bit_array.to_string(output_bits))
  let final =
    output
    |> string.split("\n")
    |> list.map(fn(p) {
      let new_p = string.split(p, "   ")
      let assert Ok(test_first) = list.first(new_p)
      let assert Ok(test_last) = list.last(new_p)
      let assert Ok(first) = int.parse(test_first)
      let assert Ok(last) = int.parse(test_last)
      #(first, last)
    })
    |> list.unzip

  let #(a, b) = final
  let sorted_a = list.sort(a, int.compare)
  let sorted_b = list.sort(b, int.compare)
  echo compare_lists(sorted_a, sorted_b)

  Ok(Nil)
}

fn ignore_error(r: Result(a, _)) -> Result(a, Nil) {
  result.map_error(r, fn(_) { Nil })
}

fn compare_lists(a: List(Int), b: List(Int)) -> Int {
  case a {
    [item_a, ..rest] -> {
      let count = list.count(b, fn(item_b) { item_a == item_b })
      let adder = case count > 0 {
        True -> count * item_a
        False -> 0
      }
      compare_lists(rest, b) + adder
    }
    _ -> 0
  }
}
