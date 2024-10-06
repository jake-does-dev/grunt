import gleeunit/should
import protobuf/version.{Version}

pub fn convert_version_test() {
  let version = Version(1, 2, "release", "os", "os_version")

  version
  |> version.encode
  |> version.decode
  |> should.equal(version)
}
