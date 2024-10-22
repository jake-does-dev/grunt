import gleeunit/should
import mumble_pb.{
  Authenticate, AuthenticateName, Ping, PingName, Version, VersionName,
}

pub fn encode_ping_test() {
  Ping
  |> mumble_pb.encode
  |> mumble_pb.decode(PingName, _)
  |> should.equal(Ping)
}

pub fn encode_version_test() {
  let version =
    Version(
      version_v1: 1,
      version_v2: 2,
      release: "rel",
      os: "os",
      os_version: "os_ver",
    )

  version
  |> mumble_pb.encode
  |> mumble_pb.decode(VersionName, _)
  |> should.equal(version)
}

pub fn authenticate_test() {
  let authenticate = Authenticate(username: "username", password: "password")

  authenticate
  |> mumble_pb.encode
  |> mumble_pb.decode(AuthenticateName, _)
  |> should.equal(authenticate)
}
