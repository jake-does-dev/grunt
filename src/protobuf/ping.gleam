import gleam/erlang/atom.{type Atom}
import gleam/io

pub type Ping {
  Ping
}

pub type PingRecord =
  #(Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom, Atom)

pub fn encode(_p: Ping) -> BitArray {
  let assert Ok(undefined) = atom.from_string("undefined")

  #(
    atom.create_from_string("Ping"),
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

pub fn decode(bin: BitArray) -> Ping {
  let record = decode_msg(bin, atom.create_from_string("Ping"))
  case record {
    _ -> {
      io.debug(record)
      Ping
    }
  }
}

@external(erlang, "mumble", "encode_msg")
fn encode_msg(erl_record: PingRecord) -> BitArray

@external(erlang, "mumble", "decode_msg")
fn decode_msg(bin: BitArray, message_name: Atom) -> PingRecord
