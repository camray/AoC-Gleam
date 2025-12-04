import gleeunit
import part_2

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn find_largest_test() {
  let value = "12345"
  assert part_2.find_largest(value, start_from: 0, drop_ending: 0) == #("5", 4)

  let value = "91801111"
  assert part_2.find_largest(value, start_from: 1, drop_ending: 0) == #("8", 2)

  let value = "170111189"
  assert part_2.find_largest(value, start_from: 0, drop_ending: 1) == #("8", 7)
}

pub fn process_battery_bank_test() {
  let bank = "234234234234278"
  assert part_2.process_battery_bank(bank) == 434_234_234_278
}
