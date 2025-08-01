(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! NS0
include NSSet_intf

type ('elt, 'compare_elt) t = ('elt, 'compare_elt) OSet.t [@@deriving compare, equal, sexp]

type 'compare_elt compare = 'compare_elt OSet.compare [@@deriving compare, equal, sexp]

module Make_from_Comparer (Elt : sig
  type t [@@deriving equal, sexp_of]

  include NSComparer.S with type t := t
end) =
struct
  module S = OSet.Make [@inlined] (Elt)

  type elt = Elt.t

  type compare_elt = Elt.compare

  type t = S.t [@@deriving compare]

  type compare = S.compare [@@deriving compare, equal, sexp]

  let comparer = S.comparer

  include S.Provide_equal (Elt)
  include S.Provide_sexp_of (Elt)
  module Provide_of_sexp = S.Provide_of_sexp
  include Iter.Set.Adapt (S)

  let empty = S.empty

  let of_ = S.singleton

  let of_option xo = NSOption.map_or ~f:S.singleton xo ~default:empty

  let add x s = S.add x s

  let add_option = NSOption.fold ~f:add

  let add_list xs s = S.union (S.of_list xs) s

  let remove x s = S.remove x s

  let diff = S.diff

  let inter = S.inter

  let union = S.union

  let diff_inter s t = (diff s t, inter s t)

  let diff_inter_diff s t = (diff s t, inter s t, diff t s)

  let union_list ss = NSList.fold ~f:union ss empty

  let is_empty = S.is_empty

  let cardinal = S.cardinal

  let mem = S.mem

  let subset s ~of_:t = S.subset s t

  let disjoint = S.disjoint

  let max_elt = S.max_elt_opt

  let only_elt = S.only_elt

  let classify = S.classify

  let choose = S.choose_opt

  let choose_exn = S.choose

  let pop = S.pop_opt

  let pop_exn = S.pop

  let pop_min_elt_exn s =
    let min = S.min_elt s in
    (min, S.remove min s)


  let split = S.split

  let find = S.find

  let map s ~f = S.map f s

  let flat_map s ~f = S.fold (fun x s -> S.union (f x) s) s S.empty

  let filter s ~f = S.filter f s

  let filter_map s ~f = S.filter_map f s

  let partition s ~f = S.partition f s

  let iter s ~f = S.iter f s

  let exists s ~f = S.exists f s

  let for_all s ~f = S.for_all f s

  let fold s z ~f = S.fold f s z

  let fold_map s z ~f =
    let z = ref z in
    let f x =
      let x', z' = f x !z in
      z := z' ;
      x'
    in
    let s' = map s ~f in
    (s', !z)


  let reduce xs ~f = match pop xs with Some (x, xs) -> Some (fold ~f xs x) | None -> None

  let pp_full ?pre ?suf ?(sep = (",@ " : (unit, unit) fmt)) pp_elt fs x =
    NSList.pp ?pre ?suf sep pp_elt fs (S.elements x)


  module Provide_pp (Elt : sig
    type t = elt

    val pp : t pp
  end) =
  struct
    let pp = pp_full Elt.pp

    let pp_diff fs (xs, ys) =
      let lose = diff xs ys in
      let gain = diff ys xs in
      if not (is_empty lose) then (
        Format.fprintf fs "-- %a" pp lose ;
        if not (is_empty gain) then Format.fprintf fs "@ " ) ;
      if not (is_empty gain) then Format.fprintf fs "++ %a" pp gain
  end
end
[@@inline]

module Make (Elt : sig
  type t [@@deriving compare, equal, sexp_of]
end) =
Make_from_Comparer (struct
  include Elt
  include NSComparer.Make (Elt)
end)
[@@inline]
