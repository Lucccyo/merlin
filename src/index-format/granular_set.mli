(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                                                                        *)
(*   Copyright 1996 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

open Granular_marshal

module type OrderedType =
  sig
    type t
    val compare : t -> t -> int
  end

module type S = sig
    type elt
    type s
    and t = s link

    val empty: t
    val add: elt -> t -> t
    val is_empty: t -> bool
    val mem: elt -> t -> bool
    val singleton: elt -> t
    val remove: elt -> t -> t
    val filter: (elt -> bool) -> t -> t
    val union: t -> t -> t
    val map: (elt -> elt) -> t -> t
    val iter: (elt -> unit) -> t -> unit
    val cardinal: t -> int
    val elements: t -> elt list
    val schema: Granular_marshal.iter ->
      (elt -> unit) -> s Granular_marshal.link -> unit
  end

module Make (Ord : OrderedType) : S with type elt = Ord.t