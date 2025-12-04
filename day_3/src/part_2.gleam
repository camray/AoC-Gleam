import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_2() {
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
  let #(processed_bank, _) =
    list.range(11, 0)
    |> list.fold(#("", 0), fn(acc, drop_ending) {
      let #(accumulator_bank, start_from) = acc
      let #(next_val, next_start_from) =
        find_largest(bank, start_from:, drop_ending:)

      #(accumulator_bank <> next_val, next_start_from + 1)
    })

  processed_bank
  |> int.parse
  |> result.unwrap(0)
}

pub fn find_largest(
  input: String,
  start_from start: Int,
  drop_ending drop_ending: Int,
) -> #(String, Int) {
  let end = string.length(input) - drop_ending

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
