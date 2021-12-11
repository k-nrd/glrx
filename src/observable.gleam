import gleam/list
import teardown.{Teardown}
import observer.{Observer}
import subscription.{Subscription}
import subscriber.{Subscriber}

pub opaque type Observable(t, u) {
  Observable(init: fn(Subscriber(t, u)) -> Teardown)
}

fn init(source: Observable(t, u), subber: Subscriber(t, u)) -> Teardown {
  source.init(subber)
}

pub fn new(init: fn(Subscriber(t, u)) -> Teardown) -> Observable(t, u) {
  Observable(init)
}

pub fn from_list(lst: List(t)) -> Observable(t, u) {
  new(fn(subber: Subscriber(t, u)) {
    list.each(lst, fn(v) { subscriber.next(subber, v) })
    subscriber.complete(subber)
    fn() { Nil }
  })
}

pub fn subscribe(source: Observable(t, u), obs: Observer(t, u)) -> Subscription {
  let subs = subscription.new()
  subscription.add_teardown(subs, init(source, subscriber.new(subs, obs)))
}

pub fn map(source: Observable(t, u), func: fn(t) -> r) -> Observable(r, u) {
  new(fn(subber: Subscriber(r, u)) -> Teardown {
    let projected =
      observer.new(
        on_next: fn(value: t) {
          subscriber.next(subber, func(value))
          Nil
        },
        on_error: fn(err: u) {
          subscriber.error(subber, err)
          Nil
        },
        on_complete: fn() {
          subscriber.complete(subber)
          Nil
        },
      )
    let subs = subscribe(source, projected)

    fn() {
      subscription.unsubscribe(subs)
      Nil
    }
  })
}
