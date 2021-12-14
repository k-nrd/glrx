import gleam/io
import gleam/string
import gleam/int
import observer.{Observer}
import observable.{Observable}
import subscriber.{Subscriber}
import subscription

pub fn main() {
  let my_safe_observable =
    observable.new(fn(subber: Subscriber(Int, u)) {
      subber
      |> subscriber.next(1)
      |> subscriber.next(2)
      |> subscriber.next(3)
      |> subscriber.complete()
      |> subscriber.next(4)

      fn() { io.println("Tearing down") }
    })

  let make_int_obs = fn(name: String) {
    observer.new(
      on_next: fn(v: Int) -> Nil {
        io.println(string.concat([name, " got ", int.to_string(v)]))
      },
      on_error: fn(err: String) -> Nil {
        io.println(string.concat([name, " error", err]))
      },
      on_complete: fn() -> Nil { io.println(string.concat([name, " done"])) },
    )
  }

  let make_str_obs = fn(name: String) {
    observer.new(
      on_next: fn(v: String) -> Nil {
        io.println(string.concat([name, " got ", v]))
      },
      on_error: fn(err: String) -> Nil {
        io.println(string.concat([name, " error", err]))
      },
      on_complete: fn() -> Nil { io.println(string.concat([name, " done"])) },
    )
  }

  let obs1 = make_int_obs("Observer 1")
  let obs2 = make_str_obs("Observer 2")
  let obs3 = make_int_obs("Observer 3")

  my_safe_observable
  |> observable.subscribe(obs1)
  |> subscription.unsubscribe

  my_safe_observable
  |> observable.map(fn(v) { v * 2 })
  |> observable.map(fn(v) { int.to_string(v) })
  |> observable.subscribe(obs2)
  |> subscription.unsubscribe

  observable.from_list([5, 10, 15])
  |> observable.subscribe(obs3)
  |> subscription.unsubscribe
}
