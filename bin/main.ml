open Lwt
open Cohttp
open Cohttp_lwt_unix

let today = Unix.localtime (Unix.time ())
let day = today.Unix.tm_mday
let month = today.Unix.tm_mon + 1
let year = today.Unix.tm_year + 1900

let url =
  Printf.sprintf "https://api-web.nhle.com/v1/standings/%04d-%02d-%02d" year
    month day

let body =
  Client.get (Uri.of_string url) >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body

let () =
  let body = Lwt_main.run body in
  print_endline ("Received body\n" ^ body)
