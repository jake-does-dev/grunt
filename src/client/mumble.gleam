import gleam/bit_array
import gleam/io
import gleam/result
import mug
import protobuf/mumble_pb

pub fn connect() {
  let assert Ok(socket) =
    mug.new("0.0.0.0", port: 64_738)
    |> mug.timeout(milliseconds: 500)
    |> mug.connect()

  io.println("we have connected....")
  // let assert Ok(_) = mug.send(socket, bit_array.concat(mumble_version))

  // let assert Ok(_) = mug.send(socket, bit_array.concat(mumble_version))

  io.println("Mumble version sent")

  // Receive a packet back
  let assert Ok(packet) = mug.receive(socket, timeout_milliseconds: 6000)

  packet
}

pub fn create_packet(
  message_name: mumble_pb.MessageName,
  message: mumble_pb.Message,
) -> BitArray {
  let pb_encoded = mumble_pb.encode(message)
  let payload_size = <<bit_array.byte_size(pb_encoded):32>>

  let type_number = case message_name {
    mumble_pb.VersionName -> 0
    mumble_pb.AuthenticateName -> 2
    mumble_pb.PingName -> 3
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
