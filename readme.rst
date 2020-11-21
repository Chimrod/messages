
========
Messages
========

.. default-role:: literal

.. role:: ocaml(code)
   :language: ocaml

`messages` is a library for type safe encoding and decoding messages.

This library allow you to describe messages in json, and automaticaly generate
encoder and decoder, with Ezjsonm, or Js_of_ocaml. This allow you to share the
code between the javascript client and the server.

Usage
=====

Simple example
--------------

.. code-block:: ocaml


  (* Declare the message.

  The message is a pair of a numeric id, and a text value *)
  module Content(T:Messages.S) = struct

    open T
    let content
      : ([`Id] int_atom * [`Value] str_atom, 'a) app
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


  5, value

Declaring the signature
-----------------------

The message has to be declared inside it's own module. The module is
parametrized in order to declare if the message has to be encoded or decoded.

The type app
~~~~~~~~~~~~

The type `app` represent the process of encoding or decoding the message. For
example

.. code-block:: ocaml

  (* Generic type in the message *)
  type t = ([`Id] int_atom, 'a) app

  (* Representation in message encoding *)
  type t_encode = int -> [`Id] int_atom t

  (* Representation in message decoding *)
  type t_decode = [`Id] int_atom t -> int

The type checker automaticaly derive the type from the signature, and deduce
that the parameter is an `int` here.

Primitives
~~~~~~~~~~

Each primitive takes a *tag* (like `\`Id` in the example) , which is not
encoded in the message, but is used in the message signature.

The basic primitives types are handled :

:string: :ocaml:`val str_atom: -> 'a -> ('a str_atom, string) app`
:integer: :ocaml:`val int_atom: -> 'a -> ('a int_atom, int) app`
:boolean: :ocaml:`val bool_atom: -> 'a -> ('a bool_atom, bool) app`
:float: :ocaml:`val float_atom: -> 'a -> ('a float_atom, bool) app`

Basic types
~~~~~~~~~~~

Types `option` and `list` are natively translated, and some types are provided
for pair and 3-uplet. A type named `either` allow to merge multiple types into
a single one.

Declaring new types
-------------------

Extending the library
~~~~~~~~~~~~~~~~~~~~~

You can extends the library with your new type. Let say you want for
example encode arrays natively :

First you have to declare the new signature :

.. code-block:: ocaml

  module type Custom = sig
    include Messages.S

    val array: ('a, 'b) app -> ('a array, 'b array) app
  end

and then create your own encoder and decoder :

.. code-block:: ocaml

  module EncodeArray = struct
    include Messages_json.Encode

    let array
      : ('a -> 'b t) -> 'a array -> 'b array t
      = fun f arr ->
        let to_, from = custom in
        to_ (Ezjsonm.list (fun v -> from (f v)) (Array.to_list arr))
  end

  module DecodeArray = struct
    include Messages_json.Decode

    let array
      : ('a t -> 'b) -> 'a array t -> 'b array
      = fun f arr ->
        let to_, from = custom in
        Array.of_list (Ezjsonm.get_list (fun v -> f (from v)) (to_ arr))
  end

Abstract types
~~~~~~~~~~~~~~

The type `atom` is untyped and allow you to encode anything :

.. code-block:: ocaml

  let value_str:[`Value] atom t = Encode.(atom `Value (str_atom `Str "string")) in
  let value_int:[`Value] atom t = Encode.(atom `Value (int_atom `Int 23L)) in
  …

This is however completely untyped :

.. code-block:: ocaml


  let value:[`Value] atom t = …
  let _ = Decode.(str_atom `Str (atom `Value value)) in
  let _ = Decode.(int_atom `Int (atom `Value value)) in
  …

The library does not provide any check when decoding the message. The Ezjsonm
implementation will raise exception `Parse_error of value * string`, but the
behavior in the Js_of_ocaml implementation is not specified.

The type value **cannot** be used inside the message signature :

.. code-block:: ocaml

  (* Error: The type of this module,
       functor (T : Messages.S) ->
         sig val content : ([ `Value ] T.atom, '_weak1 T.t) T.app end,
       contains type variables that cannot be generalized
  *)
  module ContentValue(T:Messages.S) = struct

    open T
    let content
      : ([`Value] atom, 'a) app
      = (atom `Value)

  end

but you can bypass with restriction with the function `inject` which let you
create (or extract) the type directly :

.. code-block:: ocaml

  module ContentValue(T:Messages.S) = struct

    open T
    let content
      : ([`Value] atom, 'a) app
      = inject

  end

Licence
=======

All the code is provided under the MIT license.

(See LICENSE.txt)
