import gleam/list
import gleam/option.{Some}
import gleam/regex.{Match}
import gleam/string
import simplifile.{type FileError}

pub type Field {
  Field(id: Int, name: String, gleam_type: String)
}

pub fn write_gleam(message: String) -> Nil {
  let assert Ok(re) = regex.from_string("message.*{")
  let num_messages =
    regex.scan(re, message)
    |> list.length()

  case num_messages {
    1 -> write_gleam_single_message(message)
    _ -> panic
  }
}

fn write_gleam_single_message(message: String) -> Nil {
  let message_name = extract_message_name(message)

  let _fields =
    message_name
    |> string.split("\n")
    |> list.reverse()
    |> list.drop(1)
    |> list.reverse()
    |> list.drop(1)

  let file = "write_type_test.gleam"

  let assert Ok(_) = write_imports(file)

  Nil
}

fn extract_message_name(message: String) -> String {
  let assert Ok(re) = regex.from_string("message (.*) {")
  case regex.scan(re, message) {
    [Match(_match, [Some(message_name)])] -> message_name
    _ -> panic
  }
}

fn write_imports(file: String) -> Result(Nil, FileError) {
  let imports =
    ["import gleam/bit_array", "import gleam/erlang/atom.{type Atom}"]
    |> string.join("\n")

  simplifile.write(to: file, contents: imports)
}
