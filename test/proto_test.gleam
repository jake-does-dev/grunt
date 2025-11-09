import gleeunit/should
import proto.{
  Authenticate, AuthenticateName, ChannelState, ChannelStateName, CryptSetup,
  CryptSetupName, Ping, PingName, ServerSync, ServerSyncName, TextMessage,
  TextMessageName, Version, VersionName,
}

pub fn ping_test() {
  Ping
  |> proto.encode
  |> proto.decode(PingName, _)
  |> should.equal(Ping)
}

pub fn version_test() {
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

pub fn text_message_test() {
  let text_message = TextMessage([1, 2], [2, 3], [3, 4], "text-message")

  text_message
  |> proto.encode
  |> proto.decode(TextMessageName, _)
  |> should.equal(text_message)
}

pub fn channel_state_test() {
  let channel_state = ChannelState(1, 2, "channel-state")

  channel_state
  |> proto.encode
  |> proto.decode(ChannelStateName, _)
  |> should.equal(channel_state)
}

pub fn crypt_setup_test() {
  let crypt_setup = CryptSetup("1", "2", "3")

  crypt_setup
  |> proto.encode
  |> proto.decode(CryptSetupName, _)
  |> should.equal(crypt_setup)
}

pub fn server_sync_test() {
  let server_sync = ServerSync(1, 2, "welcome-text", 3)

  server_sync
  |> proto.encode
  |> proto.decode(ServerSyncName, _)
  |> should.equal(server_sync)
}
