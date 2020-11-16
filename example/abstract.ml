module Abstract(T:Messages_common.S) = struct

  open T
  let content
    : ([`Value] atom, 'a) app
    = inject

end

module Encode = Abstract(Messages_json.Encode)

let json =
  Messages_json.Encode.str_atom `Str "string"
  |> Messages_json.Encode.atom `Value
  |> Encode.content
  |> Messages_json.Encode.process

let () = print_endline @@ Ezjsonm.to_string json

module Decode = Abstract(Messages_json.Decode)

let result =
  Messages_json.Decode.process json
  |> Decode.content
  |> Messages_json.Decode.atom `Value
  |> Messages_json.Decode.str_atom `Str

let () = Printf.printf "Decoded and got %s\n" result
