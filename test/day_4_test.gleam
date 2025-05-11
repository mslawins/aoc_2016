import day_4/day_4
import gleeunit/should

pub fn day_4_parse_room_test() {
  let line = "aaaaa-bbb-z-y-x-123[abxyz]"
  let expected = day_4.Room(["aaaaa", "bbb", "z", "y", "x"], 123, "abxyz")

  day_4.parse_room(line)
  |> should.equal(expected)
}

pub fn day_4_checksum_test() {
  let room = day_4.Room(["aaaaa", "bbb", "z", "y", "x"], 123, "abxyz")
  let occurrences = day_4.count_letters(room.name)
  let checksum = day_4.create_checksum(occurrences)

  checksum
  |> should.equal(room.checksum)
}

pub fn day_4_caesar_shift_test() {
  day_4.caesar_shift("a", 1) |> should.equal("b")
  day_4.caesar_shift("z", 1) |> should.equal("a")
  day_4.caesar_shift("m", 13) |> should.equal("z")
  day_4.caesar_shift("a", 26) |> should.equal("a")
  day_4.caesar_shift("a", 52) |> should.equal("a")
}
