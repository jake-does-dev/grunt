import erl_result.{type VoidResult}
import gleam/dynamic.{type Dynamic}
import gleam/erlang/atom
import gleam/result
import mug.{type Error, type Socket}

@external(erlang, "ssl", "start")
fn ssl_start() -> VoidResult(Error)

fn start() -> Result(Nil, Error) {
  ssl_start()
  |> erl_result.to_result
}

pub type SslConnectOptionName {
  Verify
}

pub type SslConnectOption =
  #(SslConnectOptionName, Dynamic)

pub type SslSocket

@external(erlang, "ssl", "connect")
fn ssl_connect(
  socket: Socket,
  options: List(SslConnectOption),
) -> Result(SslSocket, Error)

pub fn connect_unverified(
  host host: String,
  port port: Int,
  timeout timeout: Int,
) -> Result(SslSocket, Error) {
  case start() {
    Ok(Nil) -> {
      mug.new(host, port)
      |> mug.timeout(milliseconds: timeout)
      |> mug.connect()
      |> result.try(fn(socket) {
        ssl_connect(socket, [
          #(Verify, dynamic.from(atom.create_from_string("verify_none"))),
        ])
      })
    }
    Error(e) -> Error(e)
  }
}

@external(erlang, "ssl", "send")
fn ssl_send(socket: SslSocket, packet: BitArray) -> VoidResult(Error)

pub fn send(socket: SslSocket, packet: BitArray) -> Result(Nil, Error) {
  ssl_send(socket, packet)
  |> erl_result.to_result
}
