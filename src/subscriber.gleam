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
  destination: Observer(t, u),
  subscription: Subscription,
) -> Subscriber(t, u) {
  Subscriber(
    destination: destination,
    subscription: subscription,
    closed: False,
  )
}

pub fn next(subscriber: Subscriber(t, u), value: t) -> Nil {
  io.debug(subscriber)
  case subscriber.closed {
    True -> Nil
    False -> subscriber.destination.next(value)
  }
}
