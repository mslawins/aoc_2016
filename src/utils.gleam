import birl
import gleam/int
import gleam/io

pub type FnResult {
  FnResult(time_ms: Int, result: Int)
}

pub type Day {
  DayOne
}

pub type Task {
  PartOne
  PartTwo
}

pub fn measure_execution_time_in_ms(
  fn_to_measure: fn(String) -> Int,
  input: String,
) -> FnResult {
  let before = birl.utc_now()
  let result = fn_to_measure(input)
  let after = birl.utc_now()

  let before = birl.to_unix_milli(before)
  let after = birl.to_unix_milli(after)
  let execution_time = after - before

  FnResult(time_ms: execution_time, result: result)
}

pub fn print_fn_result(day: Day, task: Task, fn_result: FnResult) {
  let day = case day {
    DayOne -> "Day 1, "
  }

  let task = case task {
    PartOne -> "part one:"
    PartTwo -> "part two:"
  }
  io.println("")
  io.println(day <> task)
  io.println("Result: " <> int.to_string(fn_result.result))
  io.println("Time: " <> int.to_string(fn_result.time_ms) <> "ms")
}
