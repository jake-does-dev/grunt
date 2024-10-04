import gleam/io
import protobuf/mumble_pb.{Version}
import protobuf/pb_read

pub fn main() {
  Version(1, 2, "release", "os", "os_version")
  |> mumble_pb.encode
  |> mumble_pb.decode_version
  |> io.debug

  pb_read.read_messages("test/protobuf/pb_read_test.proto")
}
