import client/mumble_ffi.{type VoidResult}
import gleam/bit_array
import gleam/dynamic.{type Dynamic}
import gleam/erlang/atom
import gleam/io
import gleam/result
import mug.{type Error, type Socket}
import protobuf/mumble_pb

pub fn connect() {
  let assert Ok(_) =
    ssl_start()
    |> mumble_ffi.to_result()

  let assert Ok(socket) =
    mug.new("0.0.0.0", port: 64_738)
    |> mug.timeout(milliseconds: 500)
    |> mug.connect()
    |> result.try(fn(socket) {
      ssl_connect(socket, [
        //TODO: improve this, should be "verify_peer"
        #(Verify, dynamic.from(atom.create_from_string("verify_none"))),
      ])
    })

  io.debug("ssl connected")

  let assert Ok(_) =
    ssl_send(
      socket,
      create_packet(mumble_pb.Version(
        version_v1: 1,
        version_v2: 5,
        release: "grunt",
        os: "Fedora KDE Plasma",
        os_version: "40",
      )),
    )
    |> mumble_ffi.to_result

  io.println("Mumble version sent")

  let assert Ok(_) =
    ssl_send(
      socket,
      create_packet(mumble_pb.Authenticate(
        username: "jake-does-testing",
        password: "",
      )),
    )
    |> mumble_ffi.to_result

  io.println("Mumble auth sent")
  // // Receive a packet back
  // let assert Ok(packet) = mug.receive(socket, timeout_milliseconds: 6000)
  // packet
}

pub fn create_packet(message: mumble_pb.Message) -> BitArray {
  let pb_encoded = mumble_pb.encode(message)
  let payload_size = <<bit_array.byte_size(pb_encoded):32>>

  let type_number = case message {
    mumble_pb.Version(..) -> 0
    mumble_pb.Authenticate(..) -> 2
    mumble_pb.Ping -> 3
  }
  let type_number_array = <<type_number:16>>

  bit_array.concat([type_number_array, payload_size, pb_encoded])
}

pub fn read_packet(packet: BitArray) -> Result(mumble_pb.Message, String) {
  let assert <<type_number:16, rest:bits>> = packet
  let assert <<_payload_size:32, pb_encoded:bits>> = rest

  case type_number {
    0 -> Ok(mumble_pb.VersionName)
    2 -> Ok(mumble_pb.AuthenticateName)
    3 -> Ok(mumble_pb.PingName)
    _ -> Error("Unable to identify message type")
  }
  |> result.map(fn(name) { mumble_pb.decode(name, pb_encoded) })
}

@external(erlang, "ssl", "start")
pub fn ssl_start() -> VoidResult(Error)

pub type SslConnectOptionName {
  Verify
}

pub type SslConnectOption =
  #(SslConnectOptionName, Dynamic)

pub type SslSocket

@external(erlang, "ssl", "connect")
pub fn ssl_connect(
  socket: Socket,
  options: List(SslConnectOption),
) -> Result(SslSocket, Error)

@external(erlang, "ssl", "send")
pub fn ssl_send(socket: SslSocket, packet: BitArray) -> VoidResult(Error)
