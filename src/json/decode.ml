include Messages.T

type int = Stdlib.Int64.t
type string = Stdlib.String.t
type float = Stdlib.Float.t
type bool = Stdlib.Bool.t

type 'a t = Ezjsonm.value

type ('a, 'b) app = 'a t -> 'b

let list = Ezjsonm.get_list

let custom = (fun x -> x), (fun x -> x)

let inject x = x

let str_atom _ = Ezjsonm.get_string

let int_atom _ = Ezjsonm.get_int64

let bool_atom _ = Ezjsonm.get_bool

let float_atom _ = Ezjsonm.get_float

type 'a atom = 'a t
let atom
  : 'a -> 'a atom t -> 'b
  = fun _ v -> v

let pair = Ezjsonm.get_pair

let triple = Ezjsonm.get_triple

let either t =
  let index, v = Ezjsonm.get_pair Ezjsonm.get_int (fun x -> x) t in
  match index with
  | 0 -> Left v
  | 1 -> Right v
  | _ -> failwith "Not_found"

let option f = function
  | `Null  -> None
  | v -> Some (f v)

let process
  : Ezjsonm.t -> 'a t
  = function
    | `A [value] -> value
    | `A elems -> `A elems
    | `O obj -> `O obj
