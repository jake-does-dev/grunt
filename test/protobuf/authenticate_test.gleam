import gleeunit/should
import protobuf/authenticate.{Authenticate}

pub fn convert_authenticate_test() {
  let auth = Authenticate(username: "username", password: "password")

  auth
  |> authenticate.encode
  |> authenticate.decode
  |> should.equal(auth)
}
