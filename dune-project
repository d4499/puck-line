(lang dune 3.16)

(name puck_line)

(generate_opam_files true)

(source
 (github d4499/puck-line))

(authors "Dalton Bennyhoff")

(maintainers "Dalton Bennyhoff")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name puck_line)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune lwt cohttp cohttp-lwt-unix cohttp-async lwt_ssl serde serde_json)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
