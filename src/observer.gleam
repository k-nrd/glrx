pub opaque type Observer(t, u) {
  Observer(next: fn(t) -> Nil, error: fn(u) -> Nil, complete: fn() -> Nil)
}

pub fn new(
  next: fn(t) -> Nil,
  error: fn(u) -> Nil,
  complete: fn() -> Nil,
) -> Observer(t, u) {
  Observer(next: next, error: error, complete: complete)
}
