import gleeunit
import gleeunit/should
import gleam/otp/process
import subscription

pub fn main() {
  gleeunit.main()
}

// Subscriptions should unsubscribe a added teardown functions
pub fn add_teardown_test() {
  let #(sender, receiver) = process.new_channel()

  subscription.empty()
  |> subscription.add_teardown(fn() {
    process.send(sender, "hi")
    Nil
  })
  |> subscription.unsubscribe

  process.receive(receiver, 0)
  |> should.equal(Ok("hi"))
}
