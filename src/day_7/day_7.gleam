import gleam/list
import gleam/string
import inputs/day_7
import utils

pub type IP7 {
  IP7(in: List(String), out: List(String))
}

type IP7Parser {
  IP7Parser(
    in: List(String),
    out: List(String),
    in_bracket: Bool,
    current: String,
  )
}

pub fn day_7() {
  let input = day_7.day_7_input()

  let part_one = utils.measure_execution_time_in_ms(part_one, input)
  utils.print_fn_result(utils.DaySeven, utils.PartOne, part_one)

  let part_two = utils.measure_execution_time_in_ms(part_two, input)
  utils.print_fn_result(utils.DaySeven, utils.PartTwo, part_two)
}

pub fn part_one(input: String) -> utils.TaskResult {
  let tls_support_total =
    input
    |> string.split("\n")
    |> list.map(parse_line)
    |> list.fold(0, fn(acc, ip7) {
      let has_abba_out = list.any(ip7.out, fn(chunk) { contains_abba(chunk) })
      let has_no_abba_in = list.all(ip7.in, fn(chunk) { !contains_abba(chunk) })
      case has_abba_out && has_no_abba_in {
        True -> acc + 1
        False -> acc
      }
    })

  utils.IntResult(tls_support_total)
}

pub fn contains_abba(str: String) -> Bool {
  let windows =
    str
    |> string.split("")
    |> list.window(4)

  list.any(windows, fn(graphemes: List(String)) -> Bool {
    let assert [a, b, c, d] = graphemes
    a == d && b == c && a != b
  })
}

pub fn parse_line(line: String) -> IP7 {
  let initial = IP7Parser(list.new(), list.new(), False, "")
  let parsed =
    line
    |> string.to_graphemes()
    |> list.fold(initial, fn(parser: IP7Parser, grapheme: String) {
      case grapheme {
        "[" -> {
          IP7Parser(
            parser.in,
            list.append(parser.out, [parser.current]),
            True,
            "",
          )
        }
        "]" -> {
          IP7Parser(
            list.append(parser.in, [parser.current]),
            parser.out,
            False,
            "",
          )
        }
        _ -> {
          IP7Parser(
            parser.in,
            parser.out,
            parser.in_bracket,
            parser.current <> grapheme,
          )
        }
      }
    })

  IP7(parsed.in, list.append(parsed.out, [parsed.current]))
}

pub fn part_two(input: String) -> utils.TaskResult {
  let ssl_support_total =
    input
    |> string.split("\n")
    |> list.map(parse_line)
    |> list.fold(0, fn(acc, ip7) {
      let aba = list.flat_map(ip7.out, fn(str) { get_aba(str) })
      let wanted_bab =
        list.map(aba, fn(aba) {
          let assert [a, b, _] = string.split(aba, "")
          b <> a <> b
        })
      let found_bab = list.flat_map(ip7.in, fn(str) { get_aba(str) })
      let intersection =
        list.any(wanted_bab, fn(wanted_bab) {
          list.contains(found_bab, wanted_bab)
        })

      case intersection {
        True -> acc + 1
        False -> acc
      }
    })
  utils.IntResult(ssl_support_total)
}

fn get_aba(str: String) -> List(String) {
  str
  |> string.split("")
  |> list.window(3)
  |> list.filter(fn(graphemes) {
    let assert [a, _, c] = graphemes
    a == c
  })
  |> list.map(fn(graphemes) { string.concat(graphemes) })
}
