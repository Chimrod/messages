include Messages_common.T

type int = Stdlib.Int64.t
type string = Stdlib.String.t
type float = Stdlib.Float.t
type bool = Stdlib.Bool.t

type 'a t = Ezjsonm.value

type ('a, 'b) app = 'b -> 'a t

let list = Ezjsonm.list

let custom = (fun x -> x), (fun x -> x)

let inject x = x

let str_atom = fun _ -> Ezjsonm.string

let int_atom = fun _ -> Ezjsonm.int64

let bool_atom = fun _ -> Ezjsonm.bool

let float_atom = fun _ -> Ezjsonm.float

type 'a atom
let atom
  : 'a -> 'b t -> 'a atom t
  = fun _ v -> v

let pair = Ezjsonm.pair

let triple = Ezjsonm.triple

let either = function
  | Left  t -> `A [Ezjsonm.int 0; t]
  | Right t -> `A [Ezjsonm.int 1; t]

let option f = function
  | None -> `Null
  | Some t -> f t

let process = function
  | `A t -> `A t
  | `O obj -> `O obj
  | other -> `A [other]
