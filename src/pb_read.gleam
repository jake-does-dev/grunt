import gleam/list
import gleam/string
import simplifile

pub fn read_messages(proto_path: String) -> List(String) {
  let assert Ok(proto) = simplifile.read(from: proto_path)
  let assert Ok(#(_start, messages_only)) = string.split_once(proto, "message ")

  { "message " <> messages_only }
  |> string.split("\n\n")
  |> list.map(formatted)
  |> list.filter(fn(x) { !string.contains(x, "syntax = \"") })
  |> list.filter(fn(x) {
    !{ string.contains(x, "package") && string.contains(x, ";") }
  })
  |> list.filter(fn(x) { !string.contains(x, "option optimize_for = ") })
}

fn formatted(message: String) -> String {
  let splits =
    message
    |> string.split(on: "\n")

  splits
  |> list.map(fn(x) { string.trim(x) })
  |> list.filter(fn(x) { !string.contains(x, "// ") })
  |> list.filter(fn(x) { !string.is_empty(x) })
  |> list.map(fn(x) { string.replace(x, "optional", "") })
  |> list.map(fn(x) { string.replace(x, "required", "") })
  |> list.map(fn(x) { string.replace(x, "repeated", " repeated") })
  |> list.map(fn(x) { string.replace(x, "string", "String") })
  |> list.map(fn(x) { string.replace(x, "uint32", "Int") })
  |> list.map(fn(x) { string.replace(x, "int32", "Int") })
  |> list.map(fn(x) { string.replace(x, "uint64", "Int") })
  |> list.map(fn(x) { string.replace(x, "float", "Float") })
  |> list.map(fn(x) { string.replace(x, "bool", "Bool") })
  |> list.map(fn(x) { string.trim(x) })
  |> string.join(with: "\n")
}
