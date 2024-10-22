import gleam

pub type VoidResult(reason) {
  Ok
  Error(reason)
}

pub fn to_result(void_result: VoidResult(reason)) -> Result(Nil, reason) {
  case void_result {
    Ok -> gleam.Ok(Nil)
    Error(reason) -> gleam.Error(reason)
  }
}
