import gleam/io
import teardown.{Teardown}
import subscription.{Subscription}
import observer.{Observer}

pub opaque type Subscriber(t, u) {
  Subscriber(
    destination: Observer(t, u),
    subscription: Subscription,
    closed: Bool,
  )
}

pub fn new(
  subscription: Subscription,
  destination: Observer(t, u),
) -> Subscriber(t, u) {
  Subscriber(destination, subscription, False)
}

pub fn next(subber: Subscriber(t, u), value: t) -> Subscriber(t, u) {
  let dest = case subber.closed {
    True -> subber.destination
    False -> observer.next(subber.destination, value)
  }
  Subscriber(..subber, destination: dest)
}

pub fn error(subber: Subscriber(t, u), err: u) -> Subscriber(t, u) {
  let dest = case subber.closed {
    True -> subber.destination
    False -> observer.error(subber.destination, err)
  }
  Subscriber(dest, subscription.unsubscribe(subber.subscription), True)
}

pub fn complete(subber: Subscriber(t, u)) -> Subscriber(t, u) {
  let dest = case subber.closed {
    True -> subber.destination
    False -> observer.complete(subber.destination)
  }
  Subscriber(dest, subscription.unsubscribe(subber.subscription), True)
}
