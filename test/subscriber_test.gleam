import gleeunit
import gleeunit/should
import gleam/list
import gleam/otp/process
import subscriber

pub fn main() {
  gleeunit.main()
}

// Should ignore next messages after unsubscription
pub fn ignore_next_messages_after_unsub_test() {
  todo
}

// Should ignore error messages after unsubscription
pub fn ignore_error_messages_after_unsub_test() {
  todo
}

// Should ignore complete messages after unsubscription
pub fn ignore_complete_messages_after_unsub_test() {
  todo
}

// Should not be closed when other subscriber with the same observer instance
// completes
pub fn not_closed_when_other_sub_with_same_observer_completes_test() {
  todo
}

// Should have idempotent unsubscription
pub fn idempotent_unsub_test() {
  todo
}

// Should close, unsubscribe and unregister all teardowns after complete
pub fn close_unsub_and_unregister_teardowns_after_complete_test() {
  todo
}

// Should close, unsubscribe and unregister all teardowns after error
pub fn close_unsub_and_unregister_teardowns_after_error_test() {
  todo
}
