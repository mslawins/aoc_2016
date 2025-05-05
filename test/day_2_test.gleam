import gleeunit/should

import day_2/day_2
import utils

pub fn day_2_part_one_test() {
  let input =
    "ULL
RRDDD
LURDL
UUUUD"

  day_2.part_one(input)
  |> should.equal(utils.StringResult("1985"))
}

pub fn day_2_part_two_test() {
  let input =
    "ULL
RRDDD
LURDL
UUUUD"

  day_2.part_two(input)
  |> should.equal(utils.StringResult("5DB3"))
}
