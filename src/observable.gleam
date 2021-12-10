import gleam/list

pub type Teardown =
  fn() -> Nil

pub type Observer(t, u) {
  Observer(next: fn(t) -> Nil, error: fn(u) -> Nil, complete: fn() -> Nil)
}

pub type Subscription {
  Subscription(teardowns: List(Teardown))
}

pub fn add_teardown(sub: Subscription, td: Teardown) -> Subscription {
  Subscription(teardowns: [td, ..sub.teardowns])
}

pub fn unsubscribe(sub: Subscription) -> Subscription {
  list.each(sub.teardowns, fn(f) { f() })
  Subscription(teardowns: [])
}
