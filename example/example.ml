(* Declare the message.

   The message is a pair of a numeric id, and a text value *)
module Content(T:Messages.S) = struct

  open T
  let content
    : ([`Id] int_atom * [`Value] str_atom, _) app
    = pair
      (int_atom `Id)
      (str_atom `Value)

end

(* Encode the values in json *)
module Encode = Content(Messages_json.Encode)
let json:Ezjsonm.t =
  Encode.content (5L, "value")
  |> Messages_json.Encode.process

(* Extract the result *)
module Decode = Content(Messages_json.Decode)
let id, value =
  Messages_json.Decode.process json
  |> Decode.content

let () =
  Printf.printf "%Ld, %s\n" id value
