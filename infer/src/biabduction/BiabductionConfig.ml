(*
 * Copyright (c) 2009-2013, Monoidics ltd.
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd

(** Global variables *)

let set_reference_and_call_function reference value f x =
  let saved = !reference in
  let restore () = reference := saved in
  Exception.try_finally
    ~f:(fun () ->
      reference := value ;
      f x )
    ~finally:restore


(** Flag for footprint discovery mode *)
let footprint = ref true

let[@alert "-deprecated"] () =
  if Config.is_checker_enabled Biabduction then
    AnalysisGlobalState.register_ref ~init:(fun () -> true) footprint


let run_in_footprint_mode f x = set_reference_and_call_function footprint true f x

let run_in_re_execution_mode f x = set_reference_and_call_function footprint false f x

let abs_val = ref Config.biabduction_abs_val

let run_with_abs_val_equal_zero f x = set_reference_and_call_function abs_val 0 f x

let allow_leak = ref Config.biabduction_allow_leak

let[@alert "-deprecated"] () =
  if Config.is_checker_enabled Biabduction then
    AnalysisGlobalState.register_ref abs_val ~init:(fun () -> Config.biabduction_abs_val)
