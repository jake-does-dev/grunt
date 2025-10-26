import gleam/bit_array
import gleam/int
import gleam/result
import mumble_ssl.{type SslError, type SslSocket, SslMessageTypeError}
import proto

pub fn main() {
  connect("0.0.0.0", 64_738, True)
  //TODO: calling `receive(socket)` will wait until there is a new message
  // need to integrate this with OTP, most likely
}

pub fn connect(
  host: String,
  port: Int,
  ignore_cert_validation: Bool,
) -> SslSocket {
  let assert Ok(socket) = case ignore_cert_validation {
    True -> mumble_ssl.dangerous_connect(host:, port:)
    False -> mumble_ssl.connect(host, port)
  }

  let assert Ok(_) =
    send(
      socket,
      proto.Version(
        version_v1: 1,
        version_v2: 5,
        release: "grunt",
        os: "Fedora KDE Plasma",
        os_version: "40",
      ),
    )

  let assert Ok(_) =
    send(
      socket,
      proto.Authenticate(username: "jake-does-testing", password: ""),
    )

  socket
}

pub fn send(socket: SslSocket, message: proto.Message) -> Result(Nil, SslError) {
  mumble_ssl.send(socket, create_packet(message))
}

pub fn create_packet(message: proto.Message) -> BitArray {
  let pb_encoded = proto.encode(message)
  let size = bit_array.byte_size(pb_encoded)
  let payload_size = <<size:32>>

  let type_number = case message {
    proto.Version(..) -> 0
    proto.Authenticate(..) -> 2
    proto.Ping -> 3
    proto.TextMessage(..) -> 11
  }
  let type_number_array = <<type_number:16>>

  bit_array.concat([type_number_array, payload_size, pb_encoded])
}

pub type PacketInformation {
  FullBitArray(packet: BitArray)
  SegmentedBitArray(
    type_number: Int,
    payload_size: Int,
    protobuf_encoded: BitArray,
  )
}

pub fn receive(socket: SslSocket) -> Result(proto.Message, SslError) {
  mumble_ssl.receive(socket, 0)
  |> result.try(fn(packet) { read_packet(packet) })
}

pub fn read_packet(packet: BitArray) -> Result(proto.Message, SslError) {
  let assert <<type_number:16, rest:bits>> = packet
  let assert <<_payload_size:32, protobuf_encoded:bits>> = rest

  case type_number {
    0 -> Ok(proto.VersionName)
    2 -> Ok(proto.AuthenticateName)
    3 -> Ok(proto.PingName)
    11 -> Ok(proto.TextMessageName)
    _ ->
      Error(SslMessageTypeError(
        "Proto not implemented for message type "
        <> int.to_string(type_number)
        <> ". Continuing...",
      ))
  }
  |> result.map(fn(name) { proto.decode(name, protobuf_encoded) })
}
