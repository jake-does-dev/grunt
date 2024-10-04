import gleam/io
import gleam/list
import gleam/regex
import gleam/result
import gleam/string
import simplifile

pub fn blah(proto_path: String) -> Nil {
  // another idea... maybe target the `mumble.hrl` header and derive the types from the erlang records instead?
  // bit grim, but probably okay (much easier to match out what i need, and it handles the nesting for me basically too)

  let assert Ok(proto) = simplifile.read(from: proto_path)

  let regex_prepped = prep(proto)

  let _ = simplifile.write(to: "test_output.proto", contents: regex_prepped)

  let assert Ok(re) = regex.from_string("\\{(?:[^}{]*(?R)?)*+\\}")

  let _ =
    regex.scan(re, regex_prepped)
    |> list.first
    |> result.map(fn(x) { io.debug(x) })

  Nil
}

fn prep(proto: String) -> String {
  proto
  |> string.split("}\n\n")
  |> list.map(fn(x) { x <> "}}\n\n" })
  |> string.join("\n")
  |> string.split("\n")
  |> list.map(fn(x) {
    case string.starts_with(x, "message ") && string.contains(x, "{") {
      False -> x
      True -> "{" <> x
    }
  })
  |> string.join("\n")
}
