import gleam/dict
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Matrix(a) =
  dict.Dict(#(Int, Int), a)

pub fn part_1() {
  use file <- result.try(simplifile.read("input.txt"))
  let matrix = parse_matrix(file)

  matrix
  |> dict.fold(0, fn(acc, k, v) {
    case v {
      "@" -> {
        case adjacent_value(matrix, k.0, k.1) {
          n if n < 4 -> acc + 1
          _ -> acc
        }
      }
      _ -> acc
    }
  })
  |> echo

  Ok(Nil)
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

pub fn adjacent_value(matrix: Matrix(String), x: Int, y: Int) -> Int {
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
