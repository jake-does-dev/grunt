import connect
import gleam/dynamic.{type Dynamic}
import gleam/erlang/atom.{type Atom}
import gleam/io

type Person {
  Person(name: String, id: Int, email: String)
}

type PersonRecord {
  PersonRecord(#(Atom, String, Int, String))
}

pub fn main() {
  let thing = get_msg_defs()
  io.debug(thing)

  let thing = get_msg_names()
  io.debug(thing)
  let encoded_msg =
    verify_msg(
      PersonRecord(#(
        atom.create_from_string("Person"),
        "Jake",
        29,
        "test@email.com",
      )),
      atom.create_from_string("Person"),
    )
  io.debug(encoded_msg)
}

@external(erlang, "person", "get_msg_defs")
fn get_msg_defs() -> String

@external(erlang, "person", "get_msg_names")
fn get_msg_names() -> String

@external(erlang, "person", "encode_msg")
fn encode_msg(person: PersonRecord, type_: Atom) -> Dynamic

@external(erlang, "person", "verify_msg")
fn verify_msg(person: PersonRecord, type_: Atom) -> Dynamic
