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
}

pub type MessageName {
  VersionName
  AuthenticateName
  PingName
}

pub fn encode(m: Message) -> BitArray {
  case m {
    Authenticate(user, pass) -> encode_authenticate(user, pass)
    Ping -> encode_ping()
    Version(v1, v2, rel, os, os_ver) -> encode_version(v1, v2, rel, os, os_ver)
  }
}

pub fn decode(name: MessageName, bin: BitArray) -> Message {
  case name {
    AuthenticateName -> decode_authenticate(bin)
    PingName -> decode_ping(bin)
    VersionName -> decode_version(bin)
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

@external(erlang, "mumble", "encode_msg")
fn encode_msg(m: message) -> BitArray

// Decoders

fn decode_authenticate(bin: BitArray) -> Message {
  let record = decode_authenticate_record(bin, atom.create("Authenticate"))
  case record {
    #(_, username, password, _, _, _, _) -> {
      let assert Ok(username) = bit_array.to_string(list_to_binary(username))
      let assert Ok(password) = bit_array.to_string(list_to_binary(password))

      Authenticate(username:, password:)
    }
  }
}

@external(erlang, "mumble", "decode_msg")
fn decode_authenticate_record(
  bin: BitArray,
  message_name: Atom,
) -> AuthenticateRecordErl

type AuthenticateRecordErl =
  #(Atom, List(Int), List(Int), List(List(Int)), List(Int), Bool, Int)

// 

fn decode_ping(bin: BitArray) -> Message {
  let record = decode_ping_record(bin, atom.create("Ping"))
  case record {
    _ -> Ping
  }
}

@external(erlang, "mumble", "decode_msg")
fn decode_ping_record(bin: BitArray, message_name: Atom) -> PingRecordErl

type PingRecordErl =
  #(Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom)

//

fn decode_version(bin: BitArray) -> Message {
  let record = decode_version_record(bin, atom.create("Version"))

  case record {
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
fn decode_version_record(bin: BitArray, message_name: Atom) -> VersionRecordErl

type VersionRecordErl =
  #(Atom, Int, Int, List(Int), List(Int), List(Int))

// Helpers

@external(erlang, "erlang", "list_to_binary")
fn list_to_binary(list: List(Int)) -> BitArray
