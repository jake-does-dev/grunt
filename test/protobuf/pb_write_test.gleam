import gleam/string
import gleeunit/should
import protobuf/pb_write
import simplifile

pub fn pb_write_version_test() {
  let file = "test/protobuf/test_version.gleam"
  let message =
    [
      "message Version {", "Int version_v1 = 1;", "Int version_v2 = 5;",
      "String release = 2;", "String os = 3;", "String os_version = 4;", "}",
    ]
    |> string.join("\n")

  pb_write.write_gleam(file, message)
  let assert Ok(contents) = simplifile.read(file)

  contents
  |> should.equal(
    "import gleam/bit_array
import gleam/erlang/atom.{type Atom}

pub type Version {
	Version(
		version_v1: Int,
		release: String,
		os: String,
		os_version: String,
		version_v2: Int,
	)
}",
  )

  let assert Ok(Nil) = simplifile.delete(file)
}
