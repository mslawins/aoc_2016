import day_7/day_7
import gleeunit/should

pub fn day_7_parse_line_test() {
  let line = "abba[mnop]qrst"
  let expected = day_7.IP7(["mnop"], ["abba", "qrst"])

  day_7.parse_line(line)
  |> should.equal(expected)

  let line = "ioxxoj[asdfgh]zxcvbn"
  let expected = day_7.IP7(["asdfgh"], ["ioxxoj", "zxcvbn"])

  day_7.parse_line(line)
  |> should.equal(expected)
}

pub fn day_7_contains_abba_test() {
  day_7.contains_abba("abcdefg")
  |> should.be_false()

  day_7.contains_abba("abba")
  |> should.be_true()
}
