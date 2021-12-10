import gleam/io
import gleam/string
import gleam/int
import observable.{Observer}

pub fn main() {
  let my_observable = fn(obs: Observer(Int, a)) {
    obs.next(1)
    obs.next(2)
    obs.next(3)
    obs.complete()
    obs.next(4)
  }

  let observer =
    Observer(
      next: fn(v: Int) -> Nil {
        io.println(string.append("got ", int.to_string(v)))
      },
      error: fn(_: a) -> Nil { io.println("error") },
      complete: fn() -> Nil { io.println("done") },
    )

  my_observable(observer)
}
