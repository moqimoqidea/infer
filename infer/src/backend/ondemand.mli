(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd

(** Module for on-demand analysis. *)

val analyze_proc_name :
     AnalysisRequest.t
  -> ?specialization:Specialization.t
  -> caller_summary:Summary.t
  -> Procname.t
  -> Summary.t AnalysisResult.t
(** [analyze_proc_name exe_env ~caller_summary callee_pname] performs an on-demand analysis of
    [callee_pname] triggered during the analysis of [caller_summary] If [specialization] is given,
    the callee is requesting a specialization. *)

val analyze_proc_name_for_file_analysis :
  AnalysisRequest.t -> Procname.t -> Summary.t AnalysisResult.t
(** [analyze_proc_name_for_file_analysis exe_env callee_pname] performs an on-demand analysis of
    [callee_pname] as triggered by a file-level checker. This must not be used in any other context,
    as this will break incremental analysis. *)

val analyze_file : AnalysisRequest.t -> SourceFile.t -> unit
(** Invoke all the callbacks registered in {!Callbacks} on the given file. *)

val analyze_proc_name_toplevel :
  AnalysisRequest.t -> specialization:Specialization.t option -> Procname.t -> unit
(** Invoke all the callbacks registered in {!Callbacks} on the given procedure. *)

val edges_to_ignore : Procname.Set.t Procname.Map.t option DLS.key
(** used by the replay analysis to cut mutual recursion cycles in the same places again *)
