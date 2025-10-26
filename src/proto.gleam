import gleam/bit_array
import gleam/erlang/atom.{type Atom}

pub type Message {
  Version(
    version_v1: Int,
    version_v2: Int,
    release: String,
    os: String,
    os_version: String,
  )
  Authenticate(username: String, password: String)
  Ping
  TextMessage(
    session: List(Int),
    channel_id: List(Int),
    tree_id: List(Int),
    message: String,
  )
  ChannelState(channel_id: Int, parent: Int, name: String)
}

pub type MessageName {
  VersionName
  AuthenticateName
  PingName
  TextMessageName
  ChannelStateName
}

pub fn encode(m: Message) -> BitArray {
  case m {
    Authenticate(user, pass) -> encode_authenticate(user, pass)
    Ping -> encode_ping()
    Version(v1, v2, rel, os, os_ver) -> encode_version(v1, v2, rel, os, os_ver)
    TextMessage(session, channel_id, tree_id, message) ->
      encode_text_message(session, channel_id, tree_id, message)
    ChannelState(channel_id, parent, name) ->
      encode_channel_state(channel_id, parent, name)
  }
}

pub fn decode(name: MessageName, bin: BitArray) -> Message {
  case name {
    AuthenticateName -> decode_authenticate(bin)
    PingName -> decode_ping(bin)
    VersionName -> decode_version(bin)
    TextMessageName -> decode_text_message(bin)
    ChannelStateName -> decode_channel_state(bin)
  }
}

// Encoders

fn encode_authenticate(username: String, password: String) -> BitArray {
  #(atom.create("Authenticate"), username, password, [], [], False, 0)
  |> encode_msg
}

fn encode_ping() -> BitArray {
  let undefined = atom.create("undefined")

  #(
    atom.create("Ping"),
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
  )
  |> encode_msg
}

fn encode_version(
  version_v1: Int,
  version_v2: Int,
  release: String,
  os: String,
  os_version: String,
) -> BitArray {
  #(atom.create("Version"), version_v1, version_v2, release, os, os_version)
  |> encode_msg
}

fn encode_text_message(
  session: List(Int),
  channel_id: List(Int),
  tree_id: List(Int),
  message: String,
) -> BitArray {
  let undefined = atom.create("undefined")

  #(
    atom.create("TextMessage"),
    undefined,
    session,
    channel_id,
    tree_id,
    message,
  )
  |> encode_msg
}

fn encode_channel_state(channel_id: Int, parent: Int, name: String) -> BitArray {
  let undefined = atom.create("undefined")

  #(
    atom.create("ChannelState"),
    channel_id,
    parent,
    name,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
  )
  |> encode_msg
}

@external(erlang, "mumble", "encode_msg")
fn encode_msg(m: message) -> BitArray

// Decoders

type AuthenticateRecordErl =
  #(Atom, List(Int), List(Int), List(List(Int)), List(Int), Bool, Int)

type VersionRecordErl =
  #(Atom, Int, Int, List(Int), List(Int), List(Int))

type PingRecordErl =
  #(Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom)

type TextMessageRecordErl =
  #(Atom, Int, List(Int), List(Int), List(Int), List(Int))

type ChannelStateRecordErl =
  #(
    Atom,
    Int,
    Int,
    String,
    List(Int),
    List(Int),
    List(Int),
    List(Int),
    Bool,
    Int,
    List(Int),
    Int,
    Bool,
    Bool,
  )

@external(erlang, "mumble", "decode_msg")
fn decode_authenticate_record(
  bin: BitArray,
  message_name: Atom,
) -> AuthenticateRecordErl

fn decode_authenticate(bin: BitArray) -> Message {
  case decode_authenticate_record(bin, atom.create("Authenticate")) {
    #(_, username, password, _, _, _, _) -> {
      let assert Ok(username) = bit_array.to_string(list_to_binary(username))
      let assert Ok(password) = bit_array.to_string(list_to_binary(password))

      Authenticate(username:, password:)
    }
  }
}

@external(erlang, "mumble", "decode_msg")
fn decode_ping_record(bin: BitArray, message_name: Atom) -> PingRecordErl

fn decode_ping(bin: BitArray) -> Message {
  case decode_ping_record(bin, atom.create("Ping")) {
    _ -> Ping
  }
}

@external(erlang, "mumble", "decode_msg")
fn decode_version_record(bin: BitArray, message_name: Atom) -> VersionRecordErl

fn decode_version(bin: BitArray) -> Message {
  case decode_version_record(bin, atom.create("Version")) {
    #(_, version_v1, version_v2, release, os, os_version) -> {
      let assert Ok(release) = bit_array.to_string(list_to_binary(release))
      let assert Ok(os) = bit_array.to_string(list_to_binary(os))
      let assert Ok(os_version) =
        bit_array.to_string(list_to_binary(os_version))

      Version(version_v1, version_v2, release, os, os_version)
    }
  }
}

@external(erlang, "mumble", "decode_msg")
fn decode_text_message_record(
  bin: BitArray,
  message_name: Atom,
) -> TextMessageRecordErl

fn decode_text_message(bin: BitArray) -> Message {
  case decode_text_message_record(bin, atom.create("TextMessage")) {
    #(_, _, session, channel_id, tree_id, message) -> {
      let assert Ok(message) = bit_array.to_string(list_to_binary(message))
      TextMessage(session:, channel_id:, tree_id:, message:)
    }
  }
}

@external(erlang, "mumble", "decode_msg")
fn decode_channel_state_record(
  bin: BitArray,
  message_name: Atom,
) -> ChannelStateRecordErl

fn decode_channel_state(bin: BitArray) -> Message {
  case decode_channel_state_record(bin, atom.create("ChannelState")) {
    #(_, channel_id, parent, name, _, _, _, _, _, _, _, _, _, _) -> {
      ChannelState(channel_id:, parent:, name:)
    }
  }
}

// Helpers

@external(erlang, "erlang", "list_to_binary")
fn list_to_binary(list: List(Int)) -> BitArray
