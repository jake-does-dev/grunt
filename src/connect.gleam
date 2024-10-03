import gleam/bit_array
import gleam/io
import mug

const mumble_version = [<<1:size(16)>>, <<2:size(8)>>, <<8:size(8)>>]

pub fn connect() {
  let assert Ok(socket) =
    mug.new("0.0.0.0", port: 64_738)
    |> mug.timeout(milliseconds: 500)
    |> mug.connect()

  io.println("we have connected....")
  let assert Ok(_) = mug.send(socket, bit_array.concat(mumble_version))

  let assert Ok(_) = mug.send(socket, bit_array.concat(mumble_version))

  io.println("Mumble version sent")

  // Receive a packet back
  let assert Ok(packet) = mug.receive(socket, timeout_milliseconds: 6000)

  packet
}
