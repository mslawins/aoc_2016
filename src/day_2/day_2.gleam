import gleam/list
import gleam/string
import inputs/day_2
import utils

pub fn day_2() {
  let input = day_2.day_2_input()
  let part_one = utils.measure_execution_time_in_ms(part_one, input)
  utils.print_fn_result(utils.DayTwo, utils.PartOne, part_one)

  let part_two = utils.measure_execution_time_in_ms(part_two, input)
  utils.print_fn_result(utils.DayTwo, utils.PartTwo, part_two)
}

pub fn part_one(input: String) -> utils.TaskResult {
  generate_code(input, move_on_square_keypad)
}

pub fn part_two(input: String) -> utils.TaskResult {
  generate_code(input, move_on_diamond_keypad)
}

fn generate_code(
  input: String,
  move: fn(String, String) -> String,
) -> utils.TaskResult {
  let result =
    input
    |> string.split("\n")
    |> list.fold([], fn(keys, instructions) {
      let previous_key = case list.last(keys) {
        Ok(key) -> key
        Error(_) -> "5"
      }
      let key =
        instructions
        |> string.split("")
        |> list.fold(previous_key, fn(key, instruction) {
          move(key, instruction)
        })

      list.append(keys, [key])
    })
    |> string.join("")

  utils.StringResult(result)
}

fn move_on_square_keypad(position: String, side: String) -> String {
  case position, side {
    "1", "U" -> "1"
    "1", "R" -> "2"
    "1", "D" -> "4"
    "1", "L" -> "1"
    "2", "U" -> "2"
    "2", "R" -> "3"
    "2", "D" -> "5"
    "2", "L" -> "1"
    "3", "U" -> "3"
    "3", "R" -> "3"
    "3", "D" -> "6"
    "3", "L" -> "2"
    "4", "U" -> "1"
    "4", "R" -> "5"
    "4", "D" -> "7"
    "4", "L" -> "4"
    "5", "U" -> "2"
    "5", "R" -> "6"
    "5", "D" -> "8"
    "5", "L" -> "4"
    "6", "U" -> "3"
    "6", "R" -> "6"
    "6", "D" -> "9"
    "6", "L" -> "5"
    "7", "U" -> "4"
    "7", "R" -> "8"
    "7", "D" -> "7"
    "7", "L" -> "7"
    "8", "U" -> "5"
    "8", "R" -> "9"
    "8", "D" -> "8"
    "8", "L" -> "7"
    "9", "U" -> "6"
    "9", "R" -> "9"
    "9", "D" -> "9"
    "9", "L" -> "8"
    _, _ -> panic
  }
}

fn move_on_diamond_keypad(position: String, dir: String) -> String {
  case position, dir {
    "1", "U" -> "1"
    "1", "R" -> "1"
    "1", "D" -> "3"
    "1", "L" -> "1"
    "2", "U" -> "2"
    "2", "R" -> "3"
    "2", "D" -> "6"
    "2", "L" -> "2"
    "3", "U" -> "1"
    "3", "R" -> "4"
    "3", "D" -> "7"
    "3", "L" -> "2"
    "4", "U" -> "4"
    "4", "R" -> "4"
    "4", "D" -> "8"
    "4", "L" -> "3"
    "5", "U" -> "5"
    "5", "R" -> "6"
    "5", "D" -> "5"
    "5", "L" -> "5"
    "6", "U" -> "2"
    "6", "R" -> "7"
    "6", "D" -> "A"
    "6", "L" -> "5"
    "7", "U" -> "3"
    "7", "R" -> "8"
    "7", "D" -> "B"
    "7", "L" -> "6"
    "8", "U" -> "4"
    "8", "R" -> "9"
    "8", "D" -> "C"
    "8", "L" -> "7"
    "9", "U" -> "9"
    "9", "R" -> "9"
    "9", "D" -> "9"
    "9", "L" -> "8"
    "A", "U" -> "6"
    "A", "R" -> "B"
    "A", "D" -> "A"
    "A", "L" -> "A"
    "B", "U" -> "7"
    "B", "R" -> "C"
    "B", "D" -> "D"
    "B", "L" -> "A"
    "C", "U" -> "8"
    "C", "R" -> "C"
    "C", "D" -> "C"
    "C", "L" -> "B"
    "D", "U" -> "B"
    "D", "R" -> "D"
    "D", "D" -> "D"
    "D", "L" -> "D"
    _, _ -> panic
  }
}
