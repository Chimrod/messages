module T = struct

  type 'a str_atom

  type 'a int_atom

  type 'a bool_atom

  type 'a float_atom

  type 'a atom

  type ('a, 'b) either =
    | Left of 'a
    | Right of 'b

end

module type S = sig

  type 'a t

  type string

  type int

  type float

  type bool

  type ('a, 'b) app

  include module type of T

  val str_atom: 'a -> ('a str_atom, string) app

  val int_atom: 'a -> ('a int_atom, int) app

  val bool_atom: 'a -> ('a bool_atom, bool) app

  val float_atom: 'a -> ('a float_atom, float) app

  (*
  (** The function [inject] allow you to insert or extract already
      typed elements values and let you manage the result by yourself.
  *)
  val inject: ('a, 'a t) app
  *)

  (** [atom] gives you the possibility to hide any value inside a single value.

      let value =  Encode.atom `Str (Encode.str_atom `Str "string") in
      let value =  Encode.atom `Int (Encode.int_atom `Int 23L) in

      This is however completely untyped :

      let _ =  Decode.str_atom `Str (Decode.atom `Value value) in
      let _ =  Decode.int_atom `Int (Decode.atom `Value value) in

      If the type does not match the expected signature,
      [exception Parse_error of value * string] is raised.

  *)
  val atom: 'a -> ('a atom, 'b t) app

  val inject: ('a, 'a t) app

  val list: ('a, 'b) app -> ('a list, 'b list) app

  val pair: ('a_, 'a) app -> ('b_, 'b) app -> (('a_ * 'b_), ('a * 'b)) app

  val triple: ('a_, 'a) app -> ('b_, 'b) app -> ('c_, 'c) app ->
    (('a_ * 'b_ * 'c_ ), ('a * 'b * 'c)) app

  val either : (('a, 'b) either, ('a t, 'b t) either) app

  val option: ('a, 'b) app -> ('a option, 'b option) app

end
