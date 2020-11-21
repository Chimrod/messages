(**
   Type definition
*)
module type Custom = sig
  include Messages.S

  val array: ('a, 'b) app -> ('a array, 'b array) app
end


(**
   Custom encoder
*)
module EncodeArray = struct
  include Messages_json.Encode

  let array
    : ('a -> 'b t) -> 'a array -> 'b array t
    = fun f arr ->
      let to_, from = custom in
      to_ (Ezjsonm.list (fun v -> from (f v)) (Array.to_list arr))
end

(**
    Custom decoder
*)
module DecodeArray = struct
  include Messages_json.Decode

  let array
    : ('a t -> 'b) -> 'a array t -> 'b array
    = fun f arr ->
      let to_, from = custom in
      Array.of_list (Ezjsonm.get_list (fun v -> f (from v)) (to_ arr))
end

(**
    Implementation
*)

module Custom(T:Custom) = struct
  open T
  let content
    : ([`Prices] float_atom array, _) app
    = array
      (float_atom `Prices)
end

module EncodeCustom = Custom(EncodeArray)

module DecodeCustom = Custom(DecodeArray)

let json':Ezjsonm.t =
  EncodeCustom.content [|5.0; 2.0|]
  |> EncodeArray.process


let () = print_endline @@ Ezjsonm.to_string json'

