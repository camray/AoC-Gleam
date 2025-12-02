import advent_day_1_part_2.{RunningResult}
import gleam/list
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn part_2_subtract_test() {
  let default = RunningResult(location: 0, zero_hits: 0)
  let results = [
    #(RunningResult(..default, location: 10), 110, 2),
    #(RunningResult(..default, location: 0), 110, 1),
    #(RunningResult(..default, location: 1), 1, 1),
    #(RunningResult(..default, location: 1), 2, 1),
    #(RunningResult(..default, location: 1000), 999, 0),
    #(RunningResult(..default, location: 1), 1000, 10),
    #(RunningResult(..default, location: 99), 98, 0),
    #(RunningResult(..default, location: 5), 305, 4),

  ]

  list.map(results, fn(result) {
    let #(running_result, value, expected) = result
    let response = advent_day_1_part_2.subtract(running_result, value)
    assert response.zero_hits == expected
  })
}

pub fn part_2_add_test() {
  let default = RunningResult(location: 0, zero_hits: 0)
  let results = [
    #(RunningResult(..default, location: 10), 110, 1),
    #(RunningResult(..default, location: 0), 110, 1),
    #(RunningResult(..default, location: 1), 1, 0),
    #(RunningResult(..default, location: 99), 1000, 10),
    #(RunningResult(..default, location: 1), 1000, 10),
    #(RunningResult(..default, location: 99), 98, 1),
    #(RunningResult(..default, location: 50), 50, 1),
  ]

  list.map(results, fn(result) {
    let #(running_result, value, expected) = result
    let response = advent_day_1_part_2.add(running_result, value)
    assert response.zero_hits == expected
  })
}
