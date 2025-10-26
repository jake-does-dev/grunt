import erl_result.{type VoidResult}
import gleam/dynamic.{type Dynamic}
import gleam/erlang/atom

@external(erlang, "ssl", "start")
fn ssl_start() -> VoidResult(SslError)

fn start() -> Result(Nil, SslError) {
  ssl_start()
  |> erl_result.to_result
}

@external(erlang, "ssl", "connect")
fn ssl_connect(
  host: atom.Atom,
  port: Int,
  options: List(SslConnectOption),
) -> Result(SslSocket, SslError)

@external(erlang, "public_key", "cacerts_get")
pub fn cacerts_get() -> Dynamic

@external(erlang, "public_key", "pkix_verify_hostname_match_fun")
fn pkix_verify_hostname_match_fun(https: atom.Atom) -> Dynamic

type SslConnectOption {
  Verify(verify_type: atom.Atom)
  Cacerts(certs: Dynamic)
  CustomizeHostnameCheck(options: List(CustomizeHostnameCheckOption))
  Active(mode: atom.Atom)
}

type CustomizeHostnameCheckOption {
  MatchFun(verify_hostname_match_fun: Dynamic)
}

pub type SslSocket

pub type SslError {
  SslStartError
  SslConnectError
  SslReadError
  SslMessageTypeError(String)
}

pub fn dangerous_connect(
  host host: String,
  port port: Int,
) -> Result(SslSocket, SslError) {
  case start() {
    Ok(Nil) ->
      ssl_connect(atom.create(host), port, [
        Verify(atom.create("verify_none")),
        Active(atom.create("false")),
      ])
    Error(_) -> Error(SslStartError)
  }
}

pub fn connect(host host: String, port port: Int) -> Result(SslSocket, SslError) {
  case start() {
    Ok(Nil) -> {
      ssl_connect(atom.create(host), port, [
        Verify(atom.create("verify_peer")),
        Cacerts(cacerts_get()),
        Active(atom.create("false")),
        CustomizeHostnameCheck([
          MatchFun(pkix_verify_hostname_match_fun(atom.create("https"))),
        ]),
      ])
    }
    Error(_) -> Error(SslConnectError)
  }
}

@external(erlang, "ssl", "send")
fn ssl_send(socket: SslSocket, packet: BitArray) -> VoidResult(SslError)

pub fn send(socket: SslSocket, packet: BitArray) -> Result(Nil, SslError) {
  ssl_send(socket, packet)
  |> erl_result.to_result
}

@external(erlang, "ssl", "recv")
fn ssl_recv(socket: SslSocket, length: Int) -> Result(List(Int), SslError)

@external(erlang, "erlang", "list_to_binary")
fn list_to_binary(list: List(Int)) -> BitArray

pub fn receive(socket: SslSocket, length: Int) -> Result(BitArray, SslError) {
  case ssl_recv(socket, length) {
    Ok(data) -> Ok(list_to_binary(data))
    Error(_) -> Error(SslReadError)
  }
}
