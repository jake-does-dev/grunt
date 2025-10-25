import gleam/bit_array
import gleam/erlang/process
import gleam/io
import gleam/result
import gleam_ssl
import mumble_pb

pub fn connect() {
  let assert Ok(socket) =
    gleam_ssl.dangerous_connect(host: "0.0.0.0", port: 64_738)

  echo "ssl connected"

  let assert Ok(_) =
    gleam_ssl.send(
      socket,
      create_packet(mumble_pb.Version(
        version_v1: 1,
        version_v2: 5,
        release: "grunt",
        os: "Fedora KDE Plasma",
        os_version: "40",
      )),
    )

  io.println("Mumble version sent")

  let assert Ok(_) =
    gleam_ssl.send(
      socket,
      create_packet(mumble_pb.Authenticate(
        username: "jake-does-testing",
        password: "",
      )),
    )

  io.println("Mumble auth sent")

  process.sleep(10_000)
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
