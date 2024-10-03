import gleam/dynamic.{type Dynamic}
import gleam/erlang/atom.{type Atom}
import gleam/io

pub type Person {
  Person(name: String, id: Int, email: String)
}

type PersonRecord =
  #(Atom, String, Int, String)

pub fn as_record(person: Person) -> PersonRecord {
  #(atom.create_from_string("Person"), person.name, person.id, person.email)
}

pub fn as_gleam(record: PersonRecord) -> Person {
  case record {
    #(_atom, name, id, email) -> Person(name, id, email)
  }
}

pub fn main() {
  let person = Person("Jake", 29, "jake@email.com")

  let encoded =
    person
    |> as_record
    |> encode_msg

  let decoded =
    encoded
    |> decode_msg(atom.create_from_string("Person"))
    |> as_gleam

  io.debug("encoded")
  io.debug(encoded)
  io.debug("decoded")
  io.debug(decoded)
}

@external(erlang, "person", "encode_msg")
fn encode_msg(person: PersonRecord) -> BitArray

@external(erlang, "person", "decode_msg")
fn decode_msg(bin: BitArray, message_name: Atom) -> PersonRecord
