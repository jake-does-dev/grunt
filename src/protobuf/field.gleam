import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Field {
  Field(id: Int, name: String, gleam_type: String)
}

pub type FieldError {
  LengthError
  IdNotAnIntError
}

/// Given a bunch of fields in the `.proto`-adjusted format, as provided inside the messages
/// from `pb_read.read_messages`, e.g., `"Int version_v1 = 1;"`, this function converts to
/// a `Field`.
/// 
/// For later use when writing the codegen for the types.  
///
pub fn extract_fields(fields: List(String)) -> Result(List(Field), FieldError) {
  fields
  |> list.map(extract_field)
  |> result.all
  |> result.map(fn(fields) {
    list.sort(fields, by: fn(f1, f2) { int.compare(f1.id, f2.id) })
  })
}

pub fn extract_field(field: String) -> Result(Field, FieldError) {
  let parts = string.split(field, " ")

  case parts {
    [gleam_type, name, _equals, id] -> {
      let id =
        id
        |> string.drop_right(1)
        |> int.parse()

      case id {
        Error(_) -> Error(IdNotAnIntError)
        Ok(id) -> Ok(Field(id: id, name: name, gleam_type: gleam_type))
      }
    }
    _ -> Error(LengthError)
  }
}
