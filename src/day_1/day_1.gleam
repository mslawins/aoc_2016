import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import inputs/day_1
import utils

pub type Position {
  Position(horizontal: Int, vertical: Int)
}

pub type Direction {
  North
  East
  West
  South
}

pub type Pose {
  Pose(position: Position, direction: Direction)
}

pub type Path {
  Path(pose: Pose, history: List(Position))
}

pub type VisitedState {
  VisitedState(visited: Dict(Position, Int), target: Option(Position))
}

pub fn day_1() {
  let input = day_1.day_1_input()
  let part_one = utils.measure_execution_time_in_ms(part_one, input)
  utils.print_fn_result(utils.DayOne, utils.PartOne, part_one)

  let part_two = utils.measure_execution_time_in_ms(part_two, input)
  utils.print_fn_result(utils.DayOne, utils.PartTwo, part_two)
}

pub fn part_one(input: String) -> Int {
  let position = Position(horizontal: 0, vertical: 0)
  let pose = Pose(position, direction: North)

  let final_pose =
    input
    |> string.split(", ")
    |> list.fold(pose, fn(state, instruction) {
      let turn = string.slice(instruction, 0, 1)
      let steps =
        instruction
        |> string.drop_start(1)
        |> int.parse()
        |> result.unwrap(-1)
      let new_direction = rotate(state.direction, turn)
      let new_position = move(steps, state.position, new_direction)
      Pose(position: new_position, direction: new_direction)
    })
  to_distance(final_pose.position)
}

pub fn part_two(input: String) -> Int {
  let position = Position(horizontal: 0, vertical: 0)
  let path = Path(pose: Pose(position, direction: North), history: [position])

  let final_path =
    input
    |> string.split(", ")
    |> list.fold(path, fn(path, instruction) {
      let turn = string.slice(instruction, 0, 1)
      let steps =
        instruction
        |> string.drop_start(1)
        |> int.parse()
        |> result.unwrap(-1)
      let new_direction = rotate(path.pose.direction, turn)
      let positions = get_positions(path.pose.position, new_direction, steps)
      let final_position = case list.last(positions) {
        Ok(position) -> position
        Error(_) -> todo("Panic!")
      }
      Path(
        Pose(final_position, new_direction),
        history: list.flatten([path.history, positions]),
      )
    })

  let initial_visited = dict.new()
  let visited_state = VisitedState(visited: initial_visited, target: None)

  let visited_state =
    final_path.history
    |> list.fold_until(visited_state, fn(state, position) {
      let updated_visited = case dict.get(state.visited, position) {
        Ok(value) -> {
          dict.insert(state.visited, position, value + 1)
        }
        Error(_) -> dict.insert(state.visited, position, 1)
      }

      case dict.get(updated_visited, position) {
        Ok(value) if value == 2 -> {
          let state =
            VisitedState(visited: updated_visited, target: Some(position))
          list.Stop(state)
        }
        _ -> {
          let state = VisitedState(visited: updated_visited, target: None)
          list.Continue(state)
        }
      }
    })

  case visited_state.target {
    Some(v) -> to_distance(v)
    None -> todo("Panic!")
  }
}

fn rotate(current_direction: Direction, turn: String) -> Direction {
  case current_direction, turn {
    North, "L" -> West
    North, "R" -> East
    East, "L" -> North
    East, "R" -> South
    South, "L" -> East
    South, "R" -> West
    West, "L" -> South
    West, "R" -> North
    _, _ -> todo("Panic!")
  }
}

fn get_positions(
  position: Position,
  direction: Direction,
  steps: Int,
) -> List(Position) {
  list.range(1, steps)
  |> list.map(fn(steps) { move(steps, position, direction) })
}

fn move(
  steps: Int,
  current_position: Position,
  current_direction: Direction,
) -> Position {
  case current_direction {
    North ->
      Position(
        horizontal: current_position.horizontal,
        vertical: current_position.vertical + steps,
      )
    East ->
      Position(
        horizontal: current_position.horizontal + steps,
        vertical: current_position.vertical,
      )
    West ->
      Position(
        horizontal: current_position.horizontal - steps,
        vertical: current_position.vertical,
      )
    South ->
      Position(
        horizontal: current_position.horizontal,
        vertical: current_position.vertical - steps,
      )
  }
}

fn to_distance(position: Position) -> Int {
  int.absolute_value(position.vertical)
  + int.absolute_value(position.horizontal)
}
