import gleam/dict
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Pos = #(Int, Int)
type Matrix(a) = dict.Dict(Pos, a)

pub fn part_2() {
  use file <- result.try(simplifile.read("input.txt"))
  let matrix =
    file
    |> parse_matrix
    |> count_total_removable

  echo matrix

  Ok(Nil)
}

pub fn count_total_removable(matrix: Matrix(String)) -> Int {
  let removable_items = find_removable_items(matrix)
  case list.length(removable_items) {
    0 -> 0
    n -> {
      matrix
      |> remove_all_removable_items(removable_items)
      |> count_total_removable
      |> fn(next) {next + n}
    }
  }
}

pub fn remove_all_removable_items(
  matrix: Matrix(String),
  items: List(Pos),
) -> Matrix(String) {
  dict.map_values(matrix, fn(key, value) {
    case list.contains(items, key) {
      True -> "."
      _ -> value
    }
  })
}

pub fn find_removable_items(matrix: Matrix(String)) -> List(Pos) {
  matrix
    |> dict.fold([], fn(acc, k, v) {
      case v {
        "@" -> {
          case count_adjacent(matrix, k.0, k.1) {
            n if n < 4 -> [#(k.0, k.1), ..acc]
            _ -> acc
          }
        }
        _ -> acc
      }
    })
}

pub fn parse_matrix(input: String) -> Matrix(String) {
  input
  |> string.split("\n")
  |> list.map(fn(a) { string.to_graphemes(a) })
  |> list.index_map(fn(line, y) {
    list.index_map(line, fn(item, x) { #(#(x, y), item) })
  })
  |> list.flatten
  |> dict.from_list
}

pub fn count_adjacent(matrix: Matrix(String), x: Int, y: Int) -> Int {
  [
    #(x - 1, y - 1),
    #(x, y - 1),
    #(x + 1, y - 1),
    #(x - 1, y),
    #(x + 1, y),
    #(x - 1, y + 1),
    #(x, y + 1),
    #(x + 1, y + 1),
  ]
  |> list.filter_map(fn(pos) { dict.get(matrix, pos) })
  |> list.fold(0, fn(acc, val) {
    case val {
      "@" -> acc + 1
      _ -> acc
    }
  })
}
