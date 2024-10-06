import gleam/list
import gleeunit/should
import protobuf/parser.{Field}

pub type Token {
  IsType
  LParen
  RParen
  Var(String)
}

pub fn parse_test() {
  parser.parse_field(
    "version_v1             :: non_neg_integer() | undefined, % = 1, optional, 32 bits",
  )
  |> should.equal(Field(field_name: "version_v1", field_type: "non_neg_integer"))
}

pub fn parse_enum_test() {
  [
    "version_v1             :: non_neg_integer() | undefined, % = 1, optional, 32 bits",
    "version_v2             :: non_neg_integer() | undefined, % = 5, optional, 64 bits",
    "release                :: unicodechardata() | undefined, % = 2, optional",
    "os                     :: unicodechardata() | undefined, % = 3, optional",
    "os_version             :: unicodechardata() | undefined % = 4, optional",
  ]
  |> list.each(parser.parse_field)
  // parser.parse_field(
  //   "type :: 'None' | 'WrongVersion' | 'InvalidUsername' | 'WrongUserPW' | 'WrongServerPW' | 'UsernameInUse' | 'ServerFull' | 'NoCertificate' | 'AuthenticatorFail' | integer() | undefined, % = 1, optional, enum Reject.RejectType",
  // )
}
