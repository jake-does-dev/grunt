import gleam/io
import gleam/option.{None, Some}
import gleam/set
import nibble
import nibble/lexer

pub type Token {
  IsType
  Pipe
  Comma
  LParen
  RParen
  Percent
  Equals
  FieldName(String)
  FieldType(String)
}

pub type Field {
  Field(field_name: String, field_type: String)
}

pub fn parse_field(input: String) {
  let lexer =
    lexer.simple([
      lexer.token("::", IsType),
      lexer.token("(", LParen),
      lexer.token(")", RParen),
      lexer.variable(set.new(), FieldName),
      lexer.variable(set.new(), FieldType),
      lexer.whitespace(Nil) |> lexer.ignore,
    ])

  let field_name_parser = {
    use tok <- nibble.take_map("expected field name")
    case tok {
      FieldName(f) -> Some(f)
      _ -> None
    }
  }

  let _field_type_parser = {
    use tok <- nibble.take_map("expected field value")
    case tok {
      FieldType(f) -> Some(f)
      _ -> None
    }
  }

  let parser = {
    use field_name <- nibble.do(field_name_parser)
    use _ <- nibble.do(nibble.token(IsType))
    // use field_type <- nibble.do(field_type_parser)
    // use _ <- nibble.do(nibble.token(LParen))
    // use _ <- nibble.do(nibble.token(RParen))

    nibble.return(Field(field_name:, field_type: "hi"))
  }

  let assert Ok(tokens) = lexer.run(input, lexer)
  io.debug(tokens)
  let assert Ok(field) = nibble.run(tokens, parser)
  field
}
