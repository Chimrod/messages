include Messages.T

type int = Stdlib.Int.t
type string = Stdlib.String.t
type float = Stdlib.Float.t
type bool = Stdlib.Bool.t

type 'a t = Ojs.t

type ('a, 'b) app = 'b -> 'a t

let list = Ojs.list_to_js

let custom = Obj.magic, Obj.magic

let inject x = x

let str_atom = fun _ -> Ojs.string_to_js

let int_atom = fun _ -> Ojs.int_to_js

let bool_atom = fun _ -> Ojs.bool_to_js

let float_atom = fun _ -> Ojs.float_to_js

type 'a atom
let atom
  : 'a -> 'b t -> 'a atom t
  = fun _ v -> v

let pair fa fb (a, b) =
  let arr = Ojs.array_make 2 in
  Ojs.array_set arr 0 (fa a);
  Ojs.array_set arr 1 (fb b);
  arr

let triple fa fb fc (a, b, c) =
  let arr = Ojs.array_make 3 in
  Ojs.array_set arr 0 (fa a);
  Ojs.array_set arr 1 (fb b);
  Ojs.array_set arr 2 (fc c);
  arr

let either = function
  | Left  t -> pair Ojs.int_to_js inject (0, t)
  | Right t -> pair Ojs.int_to_js inject (1, t)

let option = Ojs.option_to_js

let of_js_array
  : 'a Js_of_ocaml.Js.js_array Js_of_ocaml.Js.t -> 'a list t
  = Obj.magic

let process
  : 'a t -> Js_of_ocaml.Js.js_string Js_of_ocaml.Js.t
  = fun t ->
    (* Convert the result in a json object *)
    Js_of_ocaml.Json.output t

