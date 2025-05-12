import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/order.{type Order}
import gleam/string
import inputs/day_4
import utils

pub type Room {
  Room(name: List(String), sector_id: Int, checksum: String)
}

pub fn day_4() {
  let input = day_4.day_4_input()
  let part_one = utils.measure_execution_time_in_ms(part_one, input)
  utils.print_fn_result(utils.DayFour, utils.PartOne, part_one)

  let part_two = utils.measure_execution_time_in_ms(part_two, input)
  utils.print_fn_result(utils.DayFour, utils.PartTwo, part_two)
}

pub fn part_one(input: String) -> utils.TaskResult {
  let result =
    input
    |> string.split("\n")
    |> list.map(parse_room)
    |> list.filter(fn(room) {
      let occurrences = count_letters(room.name)
      let checksum = create_checksum(occurrences)
      checksum == room.checksum
    })
    |> list.fold(0, fn(accumulator, room) { accumulator + room.sector_id })
  utils.IntResult(result)
}

pub fn part_two(input: String) -> utils.TaskResult {
  let result =
    input
    |> string.split("\n")
    |> list.map(parse_room)
    |> list.filter(fn(room) {
      let occurrences = count_letters(room.name)
      let checksum = create_checksum(occurrences)
      checksum == room.checksum
    })
    |> list.map(fn(room) {
      let name = caesar_words(room.name, room.sector_id)
      Room(name, room.sector_id, room.checksum)
    })
    |> list.filter(fn(room) {
      string.join(room.name, " ") == "northpole object storage"
    })
    |> list.map(fn(room) { room.sector_id })

  let assert [sector_id] = result
  utils.IntResult(sector_id)
}

pub fn caesar_words(words: List(String), shift: Int) -> List(String) {
  words
  |> list.map(fn(word) {
    word
    |> string.to_graphemes
    |> list.map(fn(char) { caesar_shift(char, shift) })
    |> string.concat
  })
}

pub fn caesar_shift(letter: String, shift: Int) -> String {
  let assert [a_code] = string.to_utf_codepoints("a")
  let a_code = string.utf_codepoint_to_int(a_code)

  let assert [code] = string.to_utf_codepoints(letter)
  let code = string.utf_codepoint_to_int(code)

  let normalized = code - a_code
  let assert Ok(shifted) = int.modulo(normalized + shift, 26)

  let new_code = shifted + a_code
  let assert Ok(new_codepoint) = string.utf_codepoint(new_code)
  string.from_utf_codepoints([new_codepoint])
}

pub fn create_checksum(occurrences: Dict(String, Int)) -> String {
  occurrences
  |> dict.to_list
  |> list.sort(compare_fn)
  |> list.take(5)
  |> list.map(fn(v) { v.0 })
  |> string.join("")
}

fn compare_fn(a: #(String, Int), b: #(String, Int)) -> Order {
  case b.1 - a.1 {
    0 -> string.compare(a.0, b.0)
    _ -> int.compare(b.1, a.1)
  }
}

pub fn count_letters(name: List(String)) -> Dict(String, Int) {
  let name = string.join(name, "")
  name
  |> string.split("")
  |> list.fold(dict.new(), fn(accumulator, letter) {
    let total = case dict.get(accumulator, letter) {
      Ok(total) -> total + 1
      Error(_) -> 1
    }
    dict.insert(accumulator, letter, total)
  })
}

pub fn parse_room(line: String) {
  let tokens = string.split(line, "-")
  let reversed_tokens = list.reverse(tokens)

  let assert [last_token, ..rest] = reversed_tokens
  let name_tokens = list.reverse(rest)
  let assert [sector_id_str, checksum_with_bracket] =
    string.split(last_token, "[")
  let assert Ok(sector_id) = int.parse(sector_id_str)
  let checksum = string.drop_end(checksum_with_bracket, 1)

  Room(name_tokens, sector_id, checksum)
}
