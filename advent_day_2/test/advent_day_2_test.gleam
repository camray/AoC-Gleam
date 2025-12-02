import gleeunit
import part_2

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn all_chunks_are_equal_test() {
  let val = ["a", "b"]
  assert part_2.all_chunks_are_equal(val) == False

  let val = ["a", "b", "c"]
  assert part_2.all_chunks_are_equal(val) == False

  let val = ["a", "a"]
  assert part_2.all_chunks_are_equal(val) == True

  let val = ["123", "123", "123"]
  assert part_2.all_chunks_are_equal(val) == True

  let val = ["1234", "1234", "12345"]
  assert part_2.all_chunks_are_equal(val) == False

  let val = ["a"]
  assert part_2.all_chunks_are_equal(val) == True

  let val = []
  assert part_2.all_chunks_are_equal(val) == True
}

pub fn chunk_string_test() {
  let val = "abc123"
  assert part_2.chunk_string(val, 2) == ["ab", "c1", "23"]

  let val = "abc1234"
  assert part_2.chunk_string(val, 2) == ["ab", "c1", "23", "4"]

  let val = "abc123"
  assert part_2.chunk_string(val, 3) == ["abc", "123"]
}

pub fn is_invalid_test() {
  assert part_2.is_invalid(1) == False
  assert part_2.is_invalid(11) == True
  assert part_2.is_invalid(1212) == True
  assert part_2.is_invalid(12112) == False
  assert part_2.is_invalid(12) == False
  assert part_2.is_invalid(1111111) == True
  assert part_2.is_invalid(161141611416114) == True
}