import gleam/int
import gleam/list
import gleam/order.{type Order}
import gleam/string
import inputs/day_6
import utils

import gleam/dict.{type Dict}

type LetterIncidence {
  LetterIncidence(
    one: Dict(String, Int),
    two: Dict(String, Int),
    three: Dict(String, Int),
    four: Dict(String, Int),
    five: Dict(String, Int),
    six: Dict(String, Int),
    seven: Dict(String, Int),
    eight: Dict(String, Int),
  )
}

pub fn day_6() {
  let input = day_6.day_6_input()
  let part_one = utils.measure_execution_time_in_ms(part_one, input)
  utils.print_fn_result(utils.DaySix, utils.PartOne, part_one)

  let part_two = utils.measure_execution_time_in_ms(part_two, input)
  utils.print_fn_result(utils.DaySix, utils.PartTwo, part_two)
}

pub fn part_one(input: String) -> utils.TaskResult {
  let message = decode_message(input, get_most_common_char)
  utils.StringResult(message)
}

pub fn part_two(input: String) -> utils.TaskResult {
  let message = decode_message(input, get_least_common_char)
  utils.StringResult(message)
}

fn decode_message(
  input: String,
  aggregate_fn: fn(Dict(String, Int)) -> String,
) -> String {
  let incidence =
    LetterIncidence(
      dict.new(),
      dict.new(),
      dict.new(),
      dict.new(),
      dict.new(),
      dict.new(),
      dict.new(),
      dict.new(),
    )

  let result =
    input
    |> string.split("\n")
    |> list.fold(incidence, fn(incidence, line) {
      let assert [a, b, c, d, e, f, g, h] = string.split(line, "")

      let one = update_dict(incidence.one, a)
      let two = update_dict(incidence.two, b)
      let three = update_dict(incidence.three, c)
      let four = update_dict(incidence.four, d)
      let five = update_dict(incidence.five, e)
      let six = update_dict(incidence.six, f)
      let seven = update_dict(incidence.seven, g)
      let eight = update_dict(incidence.eight, h)

      LetterIncidence(one, two, three, four, five, six, seven, eight)
    })

  [
    aggregate_fn(result.one),
    aggregate_fn(result.two),
    aggregate_fn(result.three),
    aggregate_fn(result.four),
    aggregate_fn(result.five),
    aggregate_fn(result.six),
    aggregate_fn(result.seven),
    aggregate_fn(result.eight),
  ]
  |> string.concat()
}

fn get_most_common_char(d: Dict(String, Int)) -> String {
  let first =
    dict.to_list(d)
    |> list.sort(compare_fn)
    |> list.first()
  let assert Ok(first) = first
  first.0
}

fn get_least_common_char(d: Dict(String, Int)) -> String {
  let first =
    dict.to_list(d)
    |> list.sort(compare_fn)
    |> list.last()
  let assert Ok(first) = first
  first.0
}

fn compare_fn(a: #(String, Int), b: #(String, Int)) -> Order {
  int.compare(b.1, a.1)
}

fn update_dict(d: Dict(String, Int), key: String) -> Dict(String, Int) {
  let total_for_key = case dict.get(d, key) {
    Ok(value) -> value
    Error(_) -> 1
  }
  dict.insert(d, key, total_for_key + 1)
}
