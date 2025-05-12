import gleam/int
import gleam/list
import gleam/string
import inputs/day_3
import utils

pub fn day_3() {
  let input = day_3.day_3_input()
  let part_one = utils.measure_execution_time_in_ms(part_one, input)
  utils.print_fn_result(utils.DayThree, utils.PartOne, part_one)

  let part_two = utils.measure_execution_time_in_ms(part_two, input)
  utils.print_fn_result(utils.DayThree, utils.PartTwo, part_two)
}

pub fn part_one(input: String) -> utils.TaskResult {
  let triples = parse_input(input)
  let result =
    triples
    |> list.fold(0, fn(accumulator, triple) {
      let assert [a, b, c] = triple
      let found = is_triangle(a, b, c)

      case found {
        True -> accumulator + 1
        False -> accumulator
      }
    })

  utils.IntResult(result)
}

pub fn part_two(input: String) -> utils.TaskResult {
  let triples = parse_input(input)
  let result =
    triples
    |> list.transpose()
    |> list.flatten()
    |> list.sized_chunk(3)
    |> list.fold(0, fn(accumulator, triple) {
      let assert [a, b, c] = triple
      let found = is_triangle(a, b, c)
      case found {
        True -> accumulator + 1
        False -> accumulator
      }
    })

  utils.IntResult(result)
}

fn parse_input(input: String) -> List(List(Int)) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.split(" ")
    |> list.filter(fn(token) { token != "" })
    |> list.map(fn(token) {
      let assert Ok(token) = int.parse(token)
      token
    })
  })
}

fn is_triangle(a: Int, b: Int, c: Int) -> Bool {
  a + b > c && a + c > b && b + c > a
}
