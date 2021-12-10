import gleeunit
import gleeunit/should
import gleam/io
import gleam/int
import gleam/string
import observable.{Observer}

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn minimal_observable_test() {
  let my_observable = fn(obs: Observer(Int, a)) {
    obs.next(1)
    obs.next(2)
    obs.next(3)
    obs.complete()
  }

  let observer =
    Observer(
      next: fn(v: Int) -> Nil {
        io.println(string.append("here is", int.to_string(v)))
      },
      error: fn(_: a) -> Nil { io.println("error") },
      complete: fn() -> Nil { io.println("done") },
    )

  my_observable(observer)
}
