(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

include Core

[@@@warning "-unused-value-declaration"]

(* easier to write Unix than Core_unix *)
module Unix = struct
  include Core_unix

  let rename ~src:_ ~dst:_ = `Dont_use_istd_unix

  let mkdir_p ?perm:_ _name = `Dont_use_istd_unix

  let nanosleep _ = `Dont_use_istd_unix

  let readdir_opt _ = `Dont_use_istd_unix

  let mkdtemp _ = `Dont_use_istd_unix

  let putenv ~key:_ ~data:_ = `Dont_use_istd_unix

  let create_process_env ?working_dir:_ ?prog_search_path:_ ?argv0:_ ?setpgid:_ ~prog:_ ~args:_
      ~env:_ () =
    `Dont_use_istd_unix


  let create_process ~prog:_ ~args:_ = `Dont_use_istd_unix

  let open_process_in _ = `Dont_use_istd_unix

  let close_process_in _ = `Dont_use_istd_unix
end

(* we don't care about the _unix distinction *)
module Filename = struct
  include Filename
  include Filename_unix
end

(* we don't care about the _unix distinction *)
module Sys = struct
  include Sys
  include Sys_unix
end

(* easy access to sub-module *)
module DLS = struct
  include Domain.DLS

  let incr key = get key |> (fun x -> x + 1) |> set key

  let decr key = get key |> (fun x -> x - 1) |> set key
end

(* Compare police: generic compare mostly disabled. *)
let compare = No_polymorphic_compare.compare

let equal = No_polymorphic_compare.equal

let ( = ) = No_polymorphic_compare.( = )

let failwith _ : [`use_Logging_die_instead] = assert false

let failwithf _ : [`use_Logging_die_instead] = assert false

let invalid_arg _ : [`use_Logging_die_instead] = assert false

let invalid_argf _ : [`use_Logging_die_instead] = assert false

let exit = `In_general_prefer_using_Logging_exit_over_Pervasives_exit

[@@@warning "+unused-value-declaration"]

module ANSITerminal : module type of ANSITerminal = struct
  include ANSITerminal

  (* more careful about when the channel is connected to a tty *)

  let print_string = if Unix.(isatty stdout) then print_string else fun _ -> Stdlib.print_string

  let prerr_string = if Unix.(isatty stderr) then prerr_string else fun _ -> Stdlib.prerr_string

  let printf styles fmt = Format.ksprintf (fun s -> print_string styles s) fmt

  let eprintf styles fmt = Format.ksprintf (fun s -> prerr_string styles s) fmt

  let sprintf = if Unix.(isatty stderr) then sprintf else fun _ -> Printf.sprintf
end

(* HACK to make the deadcode script record dependencies on [HashNormalizer]: the "normalize" ppx in
   inferppx generates code that refers to [HashNormalizer] but that dependency is invisible to
   [ocamldep], which runs before ppx expansion. This way any file that depends on [IStd]
   automatically depends on [HashNormalizer], which is enough for now. *)
module _ = HashNormalizer
