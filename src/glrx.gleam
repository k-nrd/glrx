import gleam/io
import gleam/string
import gleam/int
import observer.{Observer}
import observable.{Observable}
import subscriber.{Subscriber}
import subscription

pub fn main() {
  let my_observable = fn(obs: Observer(Int, u)) {
    obs
    |> observer.next(1)
    |> observer.next(2)
    |> observer.next(3)
    |> observer.complete()
    |> observer.next(4)

    fn() { io.println("Tearing down") }
  }

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

  let make_int_obs = fn(who: String) {
    observer.new(
      on_next: fn(v: Int) -> Nil {
        io.println(string.concat([who, " got ", int.to_string(v)]))
      },
      on_error: fn(err: String) -> Nil {
        io.println(string.concat([who, " error", err]))
      },
      on_complete: fn() -> Nil { io.println(string.concat([who, " done"])) },
    )
  }

  let make_str_obs = fn(who: String) {
    observer.new(
      on_next: fn(v: String) -> Nil {
        io.println(string.concat([who, " got ", v]))
      },
      on_error: fn(err: String) -> Nil {
        io.println(string.concat([who, " error", err]))
      },
      on_complete: fn() -> Nil { io.println(string.concat([who, " done"])) },
    )
  }

  let obs1 = make_int_obs("Observer 1")
  let obs2 = make_int_obs("Observer 2")
  let obs3 = make_str_obs("Observer 3")
  let obs4 = make_int_obs("Observer 4")

  my_observable(obs1)

  observable.subscribe(my_safe_observable, obs2)

  let sub3 =
    my_safe_observable
    |> observable.map(fn(v) { v * 2 })
    |> observable.map(fn(v) { int.to_string(v) })
    |> observable.subscribe(obs3)

  subscription.unsubscribe(sub3)

  let sub4 =
    observable.from_list([5, 10, 15])
    |> observable.subscribe(obs4)
  subscription.unsubscribe(sub4)
}
