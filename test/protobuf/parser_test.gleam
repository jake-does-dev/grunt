import gleeunit/should
import protobuf/parser.{Field}

pub type Token {
  IsType
  LParen
  RParen
  Var(String)
}

pub fn parse_test() {
  // parser.parse_field("version_v1             :: non_neg_integer()")
  parser.parse_field("version_v1             :: ")
  |> should.equal(Field(field_name: "version_v1", field_type: "hi"))
}
