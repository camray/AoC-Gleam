import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Coordinate =
  #(Int, Int)

type Matrix =
  dict.Dict(Coordinate, String)

pub fn part_1() {
  let file = result.unwrap(simplifile.read("input.txt"), "")

  let matrix =
    file
    |> parse_matrix()
    |> matrix_fold(process_coordinate)
  print_matrix(matrix)

  dict.fold(matrix, 0, fn(acc, coordinate, value) {
    let #(x, y) = coordinate
    let above = #(x, y - 1)
    case value, dict.get(matrix, above) {
      "^", Ok("|") -> acc + 1
      _, _ -> acc
    }
  })
  |> echo
}

pub fn parse_matrix(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(a) { string.to_graphemes(a) })
  |> list.index_map(fn(line, y) {
    list.index_map(line, fn(item, x) { #(#(x, y), item) })
  })
  |> list.flatten
  |> dict.from_list
}

fn matrix_fold(matrix: Matrix, f: fn(Matrix, Coordinate) -> Matrix) -> Matrix {
  let #(max_x, max_y) =
    dict.keys(matrix)
    |> list.fold(#(0, 0), fn(acc, item) {
      #(int.max(item.0, acc.0), int.max(item.1, acc.1))
    })

  list.range(0, max_y)
  |> list.fold(matrix, fn(acc_outer, y) {
    list.range(0, max_x)
    |> list.fold(acc_outer, fn(acc_inner, x) { f(acc_inner, #(x, y)) })
  })
}

pub fn process_coordinate(matrix: Matrix, coordinate: Coordinate) -> Matrix {
  case dict.get(matrix, coordinate) {
    Ok(".") -> process_dot(matrix, coordinate)
    Ok("S") -> process_start(matrix, coordinate)
    Ok("^") -> process_splitter(matrix, coordinate)
    _ -> matrix
  }
}

pub fn process_start(matrix: Matrix, coordinate: Coordinate) -> Matrix {
  let #(x, y) = coordinate
  let below = #(x, y + 1)
  dict.insert(matrix, below, "|")
}

pub fn process_dot(matrix: Matrix, coordinate: Coordinate) -> Matrix {
  let #(x, y) = coordinate
  let above = #(x, y - 1)
  let below = #(x, y + 1)
  case dict.get(matrix, above) {
    Ok("|") -> {
      matrix
      |> dict.insert(coordinate, "|")
      |> dict.insert(below, "|")
    }
    _ -> matrix
  }
}

pub fn process_splitter(matrix: Matrix, coordinate: Coordinate) -> Matrix {
  let #(x, y) = coordinate
  let replacements = [
    #(x - 1, y),
    #(x + 1, y),
    #(x - 1, y + 1),
    #(x + 1, y + 1),
  ]

  list.fold(replacements, matrix, fn(acc, item) { dict.insert(acc, item, "|") })
}

fn print_matrix(matrix: Matrix) -> Nil {
  let #(max_x, max_y) =
    dict.keys(matrix)
    |> list.fold(#(0, 0), fn(acc, item) {
      #(int.max(item.0, acc.0), int.max(item.1, acc.1))
    })

  list.range(0, max_y)
  |> list.each(fn(y) {
    list.range(0, max_x)
    |> list.map(fn(x) { dict.get(matrix, #(x, y)) |> result.unwrap(".") })
    |> string.join("")
    |> io.println
  })
}
