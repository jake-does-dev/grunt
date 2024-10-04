import gleam/bit_array
import gleam/erlang/atom.{type Atom}

pub type Version {
	Version(
		version_v1: Int,
		release: String,
		os: String,
		os_version: String,
		version_v2: Int,
	)
}