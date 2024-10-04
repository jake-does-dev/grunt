import gleam/list
import gleam/option.{Some}
import gleam/regex.{Match}
import gleam/string
import protobuf/field.{type Field}
import simplifile.{type FileError}

/// Given a `.proto`-adjusted message from `pb_read.read_messages`, write the Gleam file for
/// this message.
/// 
pub fn write_gleam(file: String, message: String) -> Nil {
  let assert Ok(re) = regex.from_string("message.*{")
  let num_messages =
    regex.scan(re, message)
    |> list.length()

  case num_messages {
    1 -> write_gleam_single_message(file, message)
    _ -> panic
  }
}

fn write_gleam_single_message(file: String, message: String) -> Nil {
  let message_name = extract_message_name(message)

  let fields =
    message
    |> string.split("\n")
    |> list.reverse()
    |> list.drop(1)
    |> list.reverse()
    |> list.drop(1)

  let assert Ok(_) = write_imports(file)

  let assert Ok(extracted_fields) = field.extract_fields(fields)
  let assert Ok(_) = write_type(file, message_name, extracted_fields)

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
    ["import gleam/bit_array", "import gleam/erlang/atom.{type Atom}", "\n"]
    |> string.join("\n")

  simplifile.write(to: file, contents: imports)
}

fn write_type(file: String, message_name: String, fields: List(Field)) {
  let gleam_type =
    list.concat([
      [
        "pub type " <> message_name <> " {",
        "\t" <> message_name <> "(",
        ..field.as_type_strings(fields)
      ],
      ["\t)", "}"],
    ])
    |> string.join("\n")

  simplifile.append(to: file, contents: gleam_type)
}
