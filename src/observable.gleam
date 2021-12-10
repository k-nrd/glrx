import teardown.{Teardown}
import observer.{Observer}
import subscription.{Subscription}
import subscriber

pub opaque type Observable(t) {
  Observable(init: fn(Observer(t)) -> Teardown)
}

pub fn subscribe(observable: Observable(t), observer: Observer(t, u)) -> Subscription {
  let sub = subscription.new()
  let subber = subscriber.new(observer, sub)
  subscription.add(sub, observable.init(subber))
  sub
}
