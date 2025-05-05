import gleeunit/should
import utils

import day_1/day_1

pub fn day_1_part_one_test() {
  let input = "R2, L3"

  day_1.part_one(input)
  |> should.equal(utils.IntResult(5))

  let input = "R2, R2, R2"

  day_1.part_one(input)
  |> should.equal(utils.IntResult(2))

  let input = "R5, L5, R5, R3"

  day_1.part_one(input)
  |> should.equal(utils.IntResult(12))
}

pub fn day_1_part_two_test() {
  let input = "R8, R4, R4, R8"

  day_1.part_two(input)
  |> should.equal(utils.IntResult(4))
}
