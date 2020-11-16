type 'a t

(** {2. Facilities function } *)

val process: 'a t -> Ezjsonm.t

(** {2. Encoder implementation } *)

include Messages_common.S
  with type ('a, 'b) app = 'b -> 'a t
   and type 'a t := 'a t
   and type string = string
   and type int = int64
   and type float = float
   and type bool = bool

(** {2 Type explicitation} 

    The functions here the same time as the Messages_common.S signature, but
    are explicited for better comprehension.

*)

val list: ('a ->'b t) -> 'a list -> 'b list t

val str_atom: 'a -> string -> 'a str_atom t

val int_atom: 'a -> int64 -> 'a int_atom t

val bool_atom: 'a -> bool -> 'a bool_atom t

val float_atom: 'a -> float -> 'a float_atom t

val pair: ('a -> 'a_ t) -> ('b -> 'b_ t) -> ('a * 'b) -> ('a_ * 'b_) t

val triple: ('a -> 'a_ t) 
  -> ('b -> 'b_ t) 
  -> ('c -> 'c_ t) 
  ->  ('a * 'b * 'c)
  -> ('a_ * 'b_ * 'c_) t

val either : ('a t, 'b t) either -> ('a, 'b) either t

val option: ('b -> 'a t) -> 'b option -> 'a option t 

(** {2. Custom types} *)

val atom: 'a -> 'b t -> 'a atom t

val inject: 'a t -> 'a t

val custom:
  (Ezjsonm.value -> 'a t) * ('a t -> Ezjsonm.value) 
