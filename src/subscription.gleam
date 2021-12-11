import gleam/list
import teardown.{Teardown}

pub opaque type Subscription {
  Subscription(teardowns: List(Teardown))
}

pub fn new() -> Subscription {
  Subscription([])
}

pub fn add_teardown(sub: Subscription, td: Teardown) -> Subscription {
  Subscription([td, ..sub.teardowns])
}

pub fn unsubscribe(sub: Subscription) -> Subscription {
  list.each(sub.teardowns, fn(f) { f() })
  Subscription([])
}
