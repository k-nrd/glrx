pub opaque type Observer(t, u) {
  Observer(
    on_next: fn(t) -> Nil,
    on_error: fn(u) -> Nil,
    on_complete: fn() -> Nil,
  )
}

pub fn new(
  on_next n: fn(t) -> Nil,
  on_error e: fn(u) -> Nil,
  on_complete c: fn() -> Nil,
) -> Observer(t, u) {
  Observer(n, e, c)
}

pub fn next(obs: Observer(t, u), value: t) -> Observer(t, u) {
  obs.on_next(value)
  obs
}

pub fn error(obs: Observer(t, u), err: u) -> Observer(t, u) {
  obs.on_error(err)
  obs
}

pub fn complete(obs: Observer(t, u)) -> Observer(t, u) {
  obs.on_complete()
  obs
}
