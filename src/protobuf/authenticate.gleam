import gleam/bit_array
import gleam/erlang/atom.{type Atom}

pub type Authenticate {
  Authenticate(username: String, password: String)
}

type AuthenticateRecordErl =
  #(Atom, List(Int), List(Int), List(List(Int)), List(Int), Bool, Int)

type AuthenticateRecord =
  #(Atom, String, String, List(String), List(Int), Bool, Int)

pub fn encode(a: Authenticate) -> BitArray {
  #(
    atom.create_from_string("Authenticate"),
    a.username,
    a.password,
    [],
    [],
    False,
    0,
  )
  |> encode_msg
}

pub fn decode(bin: BitArray) -> Authenticate {
  let record = decode_msg(bin, atom.create_from_string("Authenticate"))
  case record {
    #(_, username, password, _, _, _, _) -> {
      let assert Ok(username) = bit_array.to_string(list_to_binary(username))
      let assert Ok(password) = bit_array.to_string(list_to_binary(password))

      Authenticate(username:, password:)
    }
  }
}

@external(erlang, "mumble", "encode_msg")
fn encode_msg(erl_record: AuthenticateRecord) -> BitArray

@external(erlang, "mumble", "decode_msg")
fn decode_msg(bin: BitArray, message_name: Atom) -> AuthenticateRecordErl

@external(erlang, "erlang", "list_to_binary")
fn list_to_binary(list: List(Int)) -> BitArray
