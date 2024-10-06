import client/mumble
import gleeunit/should
import protobuf/mumble_pb

pub fn create_packet_test() {
  let version =
    mumble_pb.Version(
      version_v1: 1,
      version_v2: 2,
      release: "release",
      os: "os",
      os_version: "os_version",
    )

  version
  |> mumble.create_packet
  |> mumble.read_packet
  |> should.equal(Ok(version))
}
