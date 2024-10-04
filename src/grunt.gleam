import gleam/io
import gleam/list
import protobuf/mumble_pb.{Version}
import protobuf/pb_read
import protobuf/pb_write
import protobuf/regex_read

pub type Inner {
  Inner
}

pub fn main() {
  Version(1, 2, "release", "os", "os_version")
  |> mumble_pb.encode
  |> mumble_pb.decode_version
  |> io.debug

  let messages = regex_read.blah("mumble.proto")
  // let messages = pb_read.blah("mumble.proto")
  // let messages = pb_read.read_messages("mumble.proto")
  // let assert Ok(first) = list.first(messages)

  // pb_write.write_gleam("write_gleam_test.gleam", first)
}
