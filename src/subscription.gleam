import gleam/list
import teardown.{Teardown}

pub opaque type Subscription {
  Subscription(
    teardowns: List(Teardown),
    children: List(Subscription),
    closed: Bool,
  )
}

fn exec_teardown(teardown: Teardown) -> Nil {
  teardown()
}

fn child_not_unique(subs: List(Subscription), sub: Subscription) -> Bool {
  subs
  |> list.any(fn(s) { s == sub })
}

pub fn new(initial_teardown: Teardown) -> Subscription {
  Subscription([initial_teardown], [], False)
}

pub fn empty() -> Subscription {
  Subscription([], [], False)
}

pub fn add_teardown(sub: Subscription, teardown: Teardown) -> Subscription {
  case sub.closed {
    True -> {
      exec_teardown(teardown)
      sub
    }
    False -> Subscription([teardown, ..sub.teardowns], sub.children, False)
  }
}

pub fn children(sub: Subscription) -> List(Subscription) {
  sub.children
}

pub fn add_child(sub: Subscription, child: Subscription) -> Subscription {
  case child.closed || child_not_unique(sub.children, child) {
    True -> sub
    False ->
      case sub.closed {
        True -> {
          child.teardowns
          |> list.each(exec_teardown)
          sub
        }
        False -> Subscription(sub.teardowns, [child, ..sub.children], False)
      }
  }
}

pub fn unsubscribe(sub: Subscription) -> Subscription {
  // Execute sub teardowns
  sub.teardowns
  |> list.each(exec_teardown)

  // Execute sub children teardowns
  sub.children
  |> list.each(fn(child: Subscription) {
    child.teardowns
    |> list.each(exec_teardown)
  })

  Subscription([], [], True)
}
