(lang dune 2.5)
(generate_opam_files true)

(name messages)
(version 0.0.1)

(license "MIT")
(authors "Sébastien Dailly")
(maintainers "Sébastien Dailly <sebastien-ocaml@chimrod.com>")
(homepage "https://github.com/Chimrod/messages")
(bug_reports "https://github.com/Chimrod/messages/issues")

(package
  (name messages)
  (synopsis "Json encoding and decoding")
  (depends
    (ocaml (>= 4.08.0))
  )
)

(package
  (name messages_json)
  (synopsis "Json encoding and decoding")
  (depends
    (ocaml (>= 4.08.0))
    (messages (>= 0.0.1))
    (ezjsonm (>= 1.2.0))
  )
)

(package
  (name messages_json_js)
  (synopsis "Json encoding and decoding")
  (depends
    (ocaml (>= 4.08.0))
    (messages (>= 0.0.1))
    (gen_js_api (>= 1.0.6))
    (js_of_ocaml (>= 3.8.0))
    (js_of_ocaml-ppx (>= 3.8.0))
  )
)
