import gleam/io
import mumble_pb.{Version}

pub fn main() {
  Version(1, 2, "release", "os", "os_version")
  |> mumble_pb.encode
  |> mumble_pb.decode_version
  |> io.debug
}
