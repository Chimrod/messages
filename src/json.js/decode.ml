include Messages_common.T

type int = Stdlib.Int.t
type string = Stdlib.String.t
type float = Stdlib.Float.t
type bool = Stdlib.Bool.t

type 'a t = Ojs.t

type ('a, 'b) app = 'a t -> 'b

let list f t =  Ojs.list_of_js f t

let custom = Obj.magic, Obj.magic

let inject x = x

let str_atom _ = Ojs.string_of_js

let int_atom _ = Ojs.int_of_js

let bool_atom _ = Ojs.bool_of_js

let float_atom _ = Ojs.float_of_js

let option = Ojs.option_of_js

type 'a atom = Ojs.t
let atom
  : 'a -> 'a atom t -> 'b
  = fun _ v -> v

let pair f1 f2 p =
  ( f1 @@ Ojs.array_get p 0
  , f2 @@ Ojs.array_get p 1)

let triple f1 f2 f3 p =
  ( f1 @@ Ojs.array_get p 0
  , f2 @@ Ojs.array_get p 1
  , f3 @@ Ojs.array_get p 2)

let either t =
  match Ojs.int_of_js (Ojs.array_get t 0) with
  | 0 -> Left (Ojs.array_get t 1)
  | 1 -> Right (Ojs.array_get t 1)
  | _ -> failwith "Not_found"

let process
  : 'a Js_of_ocaml.Js.t -> 'b t
  = Obj.magic

