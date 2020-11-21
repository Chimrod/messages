type 'a t

(** {2. Facilities function } *)

val process: 'a Js_of_ocaml.Js.t -> 'b t

(** {2. Encoder implementation } *)

include Messages.S
  with type ('a, 'b) app = 'a t -> 'b
   and type 'a t := 'a t
   and type string = Stdlib.String.t
   and type int = Stdlib.Int.t
   and type float = float
   and type bool = bool

(** {2 Type explicitation} 

    The functions here the same time as the Messages_common.S signature, but
    are explicited for better comprehension.

*)

val list: ('a t -> 'b) -> 'a list t -> 'b list

val str_atom: 'a -> 'a str_atom t -> string

val int_atom: 'a -> 'a int_atom t -> int

val bool_atom: 'a -> 'a bool_atom t -> bool

val float_atom: 'a -> 'a float_atom t -> float

val pair: ('a_ t -> 'a) -> ('b_ t -> 'b) -> ('a_ * 'b_) t -> ('a * 'b) 

val triple: ('a_ t -> 'a) 
  -> ('b_ t -> 'b) 
  -> ('c_ t -> 'c) 
  -> ('a_ * 'b_ * 'c_) t 
  -> ('a * 'b * 'c) 

val either : ('a, 'b) either t -> ('a t, 'b t) either

val option: ('a t -> 'b) -> 'a option t -> 'b option

(** {2. Custom types} *)

val atom: 'a -> 'a atom t -> 'b t

val inject: 'a t -> 'a t

val custom:
  (_ t -> 'a Js_of_ocaml.Js.t) * (_ Js_of_ocaml.Js.t -> 'a t)
