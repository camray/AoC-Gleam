import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_2() {
  use file <- result.try(simplifile.read("input.txt"))

  file
  |> string.split("\n")
  |> list.map(process_battery_bank)
  |> int.sum
  |> echo

  Ok(Nil)
}

pub fn process_battery_bank(bank: String) -> Int {
  list.range(11, 0)
  |> list.fold(#("", 0), fn(acc, drop_ending) {
    let #(result, start_from) = acc
    let #(value, index) = find_largest(bank, start_from:, drop_ending:)

    #(result <> value, index + 1)
  })
  |> fn(res) { res.0 }
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
