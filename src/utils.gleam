import birl
import gleam/int
import gleam/io

pub type TaskResult {
  IntResult(Int)
  StringResult(String)
}

pub type TaskResultWithTime {
  TaskResultWithTime(time_ms: Int, result: TaskResult)
}

pub type Day {
  DayOne
  DayTwo
  DayThree
  DayFour
  DaySix
}

pub type Task {
  PartOne
  PartTwo
}

pub fn measure_execution_time_in_ms(
  fn_to_measure: fn(String) -> TaskResult,
  input: String,
) -> TaskResultWithTime {
  let before = birl.utc_now()
  let result = fn_to_measure(input)
  let after = birl.utc_now()

  let before = birl.to_unix_milli(before)
  let after = birl.to_unix_milli(after)
  let execution_time = after - before

  TaskResultWithTime(time_ms: execution_time, result: result)
}

pub fn print_fn_result(day: Day, task: Task, task_result: TaskResultWithTime) {
  let day = case day {
    DayOne -> "Day 1, "
    DayTwo -> "Day 2, "
    DayThree -> "Day 3, "
    DayFour -> "Day 4, "
    DaySix -> "Day 6, "
  }

  let task = case task {
    PartOne -> "part one:"
    PartTwo -> "part two:"
  }

  let formatted_result = case task_result.result {
    IntResult(value) -> int.to_string(value)
    StringResult(value) -> value
  }

  io.println("")
  io.println(day <> task)
  io.println("Result: " <> formatted_result)
  io.println("Time: " <> int.to_string(task_result.time_ms) <> "ms")
}
