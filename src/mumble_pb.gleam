import gleam/bit_array
import gleam/erlang/atom.{type Atom}

pub type Version {
  Version(
    version_v1: Int,
    version_v2: Int,
    release: String,
    os: String,
    os_version: String,
  )
}

type VersionRecordListIntStrings =
  #(Atom, Int, Int, List(Int), List(Int), List(Int))

type VersionRecord =
  #(Atom, Int, Int, String, String, String)

pub fn encode(version: Version) -> BitArray {
  as_record(version)
  |> encode_msg
}

pub fn decode_version(bin: BitArray) -> Version {
  decode_msg(bin, atom.create_from_string("Version"))
  |> as_gleam
}

fn as_record(v: Version) -> VersionRecord {
  #(
    atom.create_from_string("Version"),
    v.version_v1,
    v.version_v2,
    v.release,
    v.os,
    v.os_version,
  )
}

fn as_gleam(record: VersionRecordListIntStrings) -> Version {
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

@external(erlang, "mumble", "encode_msg")
fn encode_msg(version: VersionRecord) -> BitArray

@external(erlang, "mumble", "decode_msg")
fn decode_msg(bin: BitArray, message_name: Atom) -> VersionRecordListIntStrings

@external(erlang, "erlang", "list_to_binary")
fn list_to_binary(list: List(Int)) -> BitArray