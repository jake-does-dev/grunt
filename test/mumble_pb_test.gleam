import gleeunit/should
import mumble_pb.{Version}

pub fn equivalence_test() {
  let version = Version(1, 2, "release", "os", "os_version")
  let encoded = mumble_pb.encode(version)
  let decoded = mumble_pb.decode_version(encoded)

  decoded
  |> should.equal(version)
}
