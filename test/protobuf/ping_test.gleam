import gleeunit/should
import protobuf/ping.{Ping}

pub fn convert_ping_test() {
  Ping
  |> ping.encode
  |> ping.decode
  |> should.equal(Ping)
}
