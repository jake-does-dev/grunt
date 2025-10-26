import gleeunit/should
import proto.{
  Authenticate, AuthenticateName, Ping, PingName, Version, VersionName,
}

pub fn encode_ping_test() {
  Ping
  |> proto.encode
  |> proto.decode(PingName, _)
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
  |> proto.encode
  |> proto.decode(VersionName, _)
  |> should.equal(version)
}

pub fn authenticate_test() {
  let authenticate = Authenticate(username: "username", password: "password")

  authenticate
  |> proto.encode
  |> proto.decode(AuthenticateName, _)
  |> should.equal(authenticate)
}
