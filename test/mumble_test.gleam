import gleeunit/should
import grunt
import proto

pub fn create_packet_test() {
  let version =
    proto.Version(
      version_v1: 1,
      version_v2: 2,
      release: "release",
      os: "os",
      os_version: "os_version",
    )

  let packet = grunt.create_packet(version)
  let read = grunt.read_packet(packet)
  should.equal(read, Ok(version))
}
