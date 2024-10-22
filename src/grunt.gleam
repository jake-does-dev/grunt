import client
import gleam/io

pub fn main() {
  io.println("Hello from grunt!")
  client.connect()
}
