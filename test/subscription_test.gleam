import gleeunit
import gleeunit/should
import gleam/list
import gleam/otp/process
import subscription

pub fn main() {
  gleeunit.main()
}

fn lazy_send(sender, thing) {
  fn() {
    process.send(sender, thing)
    Nil
  }
}

// Should execute added teardown functions
pub fn execute_teardown_test() {
  let #(sender, receiver) = process.new_channel()

  subscription.empty()
  |> subscription.add_teardown(lazy_send(sender, "hey"))
  |> subscription.unsubscribe

  process.receive(receiver, 0)
  |> should.equal(Ok("hey"))
}

// Should immediately execute added teardown function if it's closed
pub fn execute_teardown_immediately_if_closed_test() {
  let #(sender, receiver) = process.new_channel()

  subscription.empty()
  |> subscription.unsubscribe
  |> subscription.add_teardown(lazy_send(sender, "hey"))

  process.receive(receiver, 0)
  |> should.equal(Ok("hey"))
}

// Should unsubscribe added children
pub fn execute_children_teardown_test() {
  let #(sender, receiver) = process.new_channel()

  let child =
    subscription.empty()
    |> subscription.add_teardown(lazy_send(sender, "hey"))

  subscription.empty()
  |> subscription.add_child(child)
  |> subscription.unsubscribe

  process.receive(receiver, 0)
  |> should.equal(Ok("hey"))
}

// Should immediately execute added children teardown functions if it's closed
pub fn execute_added_child_teardowns_immediately_if_closed_test() {
  let #(sender, receiver) = process.new_channel()

  let child =
    subscription.empty()
    |> subscription.add_teardown(lazy_send(sender, "hey"))

  subscription.empty()
  |> subscription.unsubscribe
  |> subscription.add_child(child)

  process.receive(receiver, 0)
  |> should.equal(Ok("hey"))
}

// Should not add duplicated children
pub fn do_not_add_duplicated_children_test() {
  let child1 =
    subscription.empty()
    |> subscription.add_teardown(fn() { Nil })

  let child2 =
    subscription.empty()
    |> subscription.add_teardown(fn() { Nil })

  let main =
    subscription.empty()
    |> subscription.add_child(child1)
    |> subscription.add_child(child1)
    |> subscription.add_child(child2)

  main
  |> subscription.children
  |> list.length
  |> should.equal(2)
}
