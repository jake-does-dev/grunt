## Overview

### `mumble_pb.gleam`

This module is meant to function as an interop between Gleam, and the Erlang generated
protobuf files for Mumble.

To keep things fairly manageable:
- the Gleam types will contain fields that we only care about in the Mumble client
- the Erlang records
- if the tuples look confusing, refer to the `mumble.hrl` file for reference.

Recall: Erlang records are Gleam tuples where the first entry is an `atom` for the Erlang record's name