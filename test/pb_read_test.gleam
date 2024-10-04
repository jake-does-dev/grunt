import gleam/io
import gleam/list
import gleam/string
import gleeunit/should
import pb_read

pub fn read_proto_test() {
  let messages = pb_read.read_messages("test/pb_read_test.proto")

  let assert Ok(#(version, rest)) = list.pop(messages, fn(_) { True })
  let assert Ok(#(udp_tunnel, rest)) = list.pop(rest, fn(_) { True })
  let assert Ok(#(authenticate, _rest)) = list.pop(rest, fn(_) { True })

  io.debug(version)
  string.contains(version, "message Version {")
  |> should.be_true()

  string.contains(udp_tunnel, "message UDPTunnel {")
  |> should.be_true()

  string.contains(authenticate, "message Authenticate {")
  |> should.be_true()
}
