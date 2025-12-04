import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_1() {
  use file <- result.try(simplifile.read("input.txt"))
  file
  |> string.split("\n")
  |> process_battery_banks()
  |> echo

  Ok(Nil)
}

pub fn process_battery_banks(banks: List(String)) -> Int {
  list.fold(banks, 0, fn(acc, bank) { acc + process_battery_bank(bank) })
}

pub fn process_battery_bank(bank: String) -> Int {
  let #(prefix, split_at) =
    find_largest_int_and_idx(bank, start_from: 0, keep_last: False)
  let #(postfix, _) =
    find_largest_int_and_idx(bank, start_from: split_at + 1, keep_last: True)

  int.parse(prefix <> postfix)
  |> result.unwrap(0)
}

pub fn find_largest_int_and_idx(
  input: String,
  start_from start: Int,
  keep_last keep_last: Bool,
) -> #(String, Int) {
  let end = case keep_last {
    True -> string.length(input) - 1
    False -> string.length(input)
  }

  input
  |> string.to_graphemes()
  |> list.index_fold(#("0", start), fn(best, char, idx) {
    case idx >= start && idx < end {
      False -> best
      True -> {
        let #(best_char, _) = best
        case int.parse(char), int.parse(best_char) {
          Ok(current), Ok(best_char) if current > best_char -> #(char, idx)
          _, _ -> best
        }
      }
    }
  })
}
