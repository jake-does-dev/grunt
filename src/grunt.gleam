import gleam/io
import mumble

pub fn main() {
  io.println("Hello from grunt!")
  mumble.connect()
}
