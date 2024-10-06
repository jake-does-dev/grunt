import client/mumble
import gleam/io

pub fn main() {
  io.println("Hello from grunt!")
  mumble.connect()
}
