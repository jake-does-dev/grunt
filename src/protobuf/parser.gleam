import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/set
import nibble
import nibble/lexer

pub type Token {
  IsType
  Pipe
  Comma
  SingleQuote
  LSquare
  RSquare
  LParen
  RParen
  Percent
  Equals
  Optional
  Repeated
  Required
  Undefined
  NonNegInteger
  UnicodeChardata
  Enum
  Str(String)
  Num(Int)
}

pub type Field {
  Field(field_name: String, field_type: String)
}

pub fn parse_field(input: String) {
  let lexer =
    lexer.simple([
      lexer.ignore(lexer.token("undefined", Undefined)),
      lexer.ignore(lexer.token("[", LSquare)),
      lexer.ignore(lexer.token("]", RSquare)),
      lexer.ignore(lexer.whitespace(Nil)),
      lexer.ignore(lexer.token("=", Equals)),
      lexer.ignore(lexer.token("%", Percent)),
      lexer.ignore(lexer.int(Num)),
      lexer.token("::", IsType),
      lexer.token("(", LParen),
      lexer.token(")", RParen),
      lexer.token("|", Pipe),
      lexer.token(",", Comma),
      // lexer.token("'", SingleQuote),
      lexer.token("optional", Optional),
      lexer.token("repeated", Repeated),
      lexer.token("required", Required),
      lexer.token("non_neg_integer()", NonNegInteger),
      lexer.token("unicode:chardata()", UnicodeChardata),
      lexer.variable(set.new(), Str),
      // lexer.symbol("enum", "\\w", Enum),
    ])

  let string_parser = {
    use tok <- nibble.take_map("expected string")

    case tok {
      Str(f) -> Some(f)
      _ -> None
    }
  }

  let parser = {
    use field_name <- nibble.do(string_parser)
    use _ <- nibble.do(nibble.token(IsType))
    use field_type <- nibble.do(string_parser)

    use _ <- nibble.do(nibble.token(LParen))
    use _ <- nibble.do(nibble.token(RParen))

    nibble.return(Field(field_name:, field_type: field_type))
  }

  let assert Ok(tokens) = lexer.run(input, lexer)
  let assert Ok(field) = nibble.run(tokens, parser)

  io.debug(tokens)
  field
}
