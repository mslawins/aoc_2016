import gleeunit/should

import day_1/day_1

pub fn part_one_test() {
  let input = "R2, L3"

  day_1.part_one(input)
  |> should.equal(5)

  let input = "R2, R2, R2"

  day_1.part_one(input)
  |> should.equal(2)

  let input = "R5, L5, R5, R3"

  day_1.part_one(input)
  |> should.equal(12)
}

pub fn part_two_test() {
  let input = "R8, R4, R4, R8"

  day_1.part_two(input)
  |> should.equal(4)
}
