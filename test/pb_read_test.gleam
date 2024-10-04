import gleam/iterator
import gleam/string
import gleeunit/should
import pb_read

const path = "test/pb_read_test.proto"

fn read_message(index: Int) -> String {
  let messages = pb_read.read_messages(path)
  let assert Ok(val) =
    iterator.from_list(messages)
    |> iterator.at(index)
  val
}

pub fn read_version_test() {
  read_message(0)
  |> string.split("\n")
  |> should.equal([
    "message Version {", "Int version_v1 = 1;", "Int version_v2 = 5;",
    "String release = 2;", "String os = 3;", "String os_version = 4;", "}",
  ])
}

pub fn read_udp_tunnel_test() {
  read_message(1)
  |> string.split("\n")
  |> should.equal(["message UDPTunnel {", "bytes packet = 1;", "}"])
}

pub fn read_authenticate_test() {
  read_message(2)
  |> string.split("\n")
  |> should.equal([
    "message Authenticate {", "String username = 1;", "String password = 2;",
    "repeated String tokens = 3;", "repeated Int celt_versions = 4;",
    "Bool opus = 5 [default = false];", "Int client_type = 6 [default = 0];",
    "}",
  ])
}
