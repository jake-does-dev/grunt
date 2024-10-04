import gleam/string
import pb_write

pub fn pb_write_version_test() {
  let message: String =
    [
      "message Version {", "Int version_v1 = 1;", "Int version_v2 = 5;",
      "String release = 2;", "String os = 3;", "String os_version = 4;", "}",
    ]
    |> string.join("\n")

  pb_write.write_gleam(message)
  // should.fail()
}
