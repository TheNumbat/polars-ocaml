open! Core

type t

external int : string -> int list -> t = "rust_series_new_int"
external int_option : string -> int option list -> t = "rust_series_new_int_option"
external float : string -> float list -> t = "rust_series_new_float"
external float_option : string -> float option list -> t = "rust_series_new_float_option"
external bool : string -> bool list -> t = "rust_series_new_bool"
external bool_option : string -> bool option list -> t = "rust_series_new_bool_option"
external string : string -> string list -> t = "rust_series_new_string"

external string_option
  :  string
  -> string option list
  -> t
  = "rust_series_new_string_option"

external date_range
  :  string
  -> Utils.Naive_datetime.t
  -> Utils.Naive_datetime.t
  -> cast_to_date:bool
  -> (t, string) result
  = "rust_series_date_range"

let date_range_castable name ~start ~stop ~cast_to_date =
  let to_datetime date =
    Utils.Naive_date.of_date date
    |> Utils.Naive_datetime.of_naive_date
    |> Option.value_exn ~here:[%here]
  in
  date_range name (to_datetime start) (to_datetime stop) ~cast_to_date
;;

let date_range = date_range_castable ~cast_to_date:true

let date_range_exn name ~start ~stop =
  date_range name ~start ~stop |> Result.map_error ~f:Error.of_string |> Or_error.ok_exn
;;

let datetime_range = date_range_castable ~cast_to_date:false

let datetime_range_exn name ~start ~stop =
  datetime_range name ~start ~stop
  |> Result.map_error ~f:Error.of_string
  |> Or_error.ok_exn
;;

external to_string_hum : t -> string = "rust_series_to_string_hum"

let print t = print_endline (to_string_hum t)