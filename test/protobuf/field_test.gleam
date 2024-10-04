import gleeunit/should
import protobuf/field.{Field, IdNotAnIntError, LengthError}

pub fn extract_ok_field_test() {
  let incoming_field = "Int version_v1 = 1;"

  field.extract_field(incoming_field)
  |> should.equal(Ok(Field(id: 1, name: "version_v1", gleam_type: "Int")))
}

pub fn extract_error_bad_length_test() {
  let incoming_field = "Int version_v1 = = 1;"

  field.extract_field(incoming_field)
  |> should.equal(Error(LengthError))
}

pub fn extract_error_bad_id_test() {
  let incoming_field = "Int version_v1 = not_an_int_id;"

  field.extract_field(incoming_field)
  |> should.equal(Error(IdNotAnIntError))
}

pub fn extract_ok_fields_test() {
  let incoming_fields = [
    "Int version_v1 = 1;", "Int version_v2 = 5;", "String release = 2;",
    "String os = 3;", "String os_version = 4;",
  ]

  field.extract_fields(incoming_fields)
  |> should.equal(
    Ok([
      Field(id: 1, name: "version_v1", gleam_type: "Int"),
      Field(id: 2, name: "release", gleam_type: "String"),
      Field(id: 3, name: "os", gleam_type: "String"),
      Field(id: 4, name: "os_version", gleam_type: "String"),
      Field(id: 5, name: "version_v2", gleam_type: "Int"),
    ]),
  )
}

pub fn as_type_string_test() {
  Field(id: 1, name: "version_v1", gleam_type: "Int")
  |> field.as_type_string
  |> should.equal("\t\tversion_v1: Int,")
}

pub fn as_type_strings_test() {
  [
    Field(id: 1, name: "version_v1", gleam_type: "Int"),
    Field(id: 2, name: "release", gleam_type: "String"),
    Field(id: 3, name: "os", gleam_type: "String"),
    Field(id: 4, name: "os_version", gleam_type: "String"),
    Field(id: 5, name: "version_v2", gleam_type: "Int"),
  ]
  |> field.as_type_strings
  |> should.equal([
    "\t\tversion_v1: Int,", "\t\trelease: String,", "\t\tos: String,",
    "\t\tos_version: String,", "\t\tversion_v2: Int,",
  ])
}
