import client
import gleeunit/should
import mumble_pb

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
  |> client.create_packet
  |> client.read_packet
  |> should.equal(Ok(version))
}
