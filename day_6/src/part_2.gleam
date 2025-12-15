import gleam/int
import gleam/list
import gleam/string
import gleam/result
import simplifile

pub fn part_2() {
  use file <- result.try(simplifile.read("input.txt"))

  file
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.chunk(fn(items) {
    list.all(items, fn (str) { str == " " })
  })
  |> list.index_map(fn(item, idx) {
    case idx % 2 == 0 {
      True -> Ok(item)
      False -> Error(Nil)
    }
  })
  |> list.filter_map(fn (x) { x })
  |> list.map(combine)
  |> int.sum
  |> echo
  Ok(Nil)
}

pub fn combine(problem: List(List(String))) -> Int {
  let assert Ok(combinator) = problem
  |> list.first
  |> result.try(list.last)

  let inputs = problem
  |> list.map(fn(row) {
    row
    |> list.filter_map(int.parse)
    |> list.map(int.to_string)
    |> string.concat
    |> int.parse
    |> result.unwrap(0)
  })

  case combinator {
    "+" -> int.sum(inputs)
    "*" -> int.product(inputs)
    _ -> 0
  }
}
