import gleam/io
import gleam/list
import protobuf/mumble_pb.{Version}
import protobuf/pb_read
import protobuf/pb_write

pub fn main() {
  Version(1, 2, "release", "os", "os_version")
  |> mumble_pb.encode
  |> mumble_pb.decode_version
  |> io.debug

  let messages = pb_read.read_messages("test/protobuf/pb_read_test.proto")
  let assert Ok(first) = list.first(messages)

  pb_write.write_gleam("write_gleam_test.gleam", first)
}
