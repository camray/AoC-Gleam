import gleam/int
import gleam/list
import gleam/string
import gleam/result
import simplifile

pub fn part_1() {
  use file <- result.try(simplifile.read("input.txt"))

  file
  |> string.split("\n")
  |> list.map(fn (item) {
    item
    |> string.split(" ")
    |> list.filter(fn(x) {x != ""})
  })
  |> list.reverse
  |> list.transpose
  |> list.map(combine)
  |> int.sum
  |> echo
  Ok(Nil)
}

pub fn combine(problem: List(String)) -> Int {
  case problem {
    [] -> 0
    [combinator, ..rest] -> {
      let args = list.filter_map(rest, int.parse)
      case combinator {
        "+" -> int.sum(args)
        "*" -> int.product(args)
        _ -> 0
      }
    }
  }
}
