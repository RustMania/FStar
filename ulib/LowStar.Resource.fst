(*
   Copyright 2008-2019 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
module LowStar.Resource

open FStar.HyperStack.ST
module B = LowStar.Buffer
module HS = FStar.HyperStack
module HST = FStar.HyperStack.ST

(* Views and resources *)

let imem inv = m:HS.mem{inv m}

let eloc = Ghost.erased B.loc
let as_loc (x:eloc) : GTot B.loc = Ghost.reveal x

abstract
let sel_reads_fp #b fp #inv (sel:(imem inv) -> GTot b) =
  forall (h0 h1:imem inv) loc. {:pattern  (B.modifies loc h0 h1); (sel h1)}
    B.loc_disjoint (as_loc fp) loc /\
    B.modifies loc h0 h1 ==>
    sel h0 == sel h1

abstract
let inv_reads_fp fp inv =
  forall h0 h1 loc.{:pattern (B.modifies loc h0 h1); (inv h1)}
    inv h0 /\
    B.loc_disjoint (as_loc fp) loc /\
    B.modifies loc h0 h1 ==>
    inv h1

unfold
let view_t a b = a -> GTot b

noeq 
type view_aux a = {
    fp: eloc;
    inv: HS.mem -> Type0;
    sel: view_t (imem inv) a
  }

let view a = 
  view:view_aux a{
    sel_reads_fp view.fp view.sel /\
    inv_reads_fp view.fp view.inv
  }

let reveal_view ()
  : Lemma ((forall #b fp #inv (sel:(imem inv) -> GTot b) .{:pattern sel_reads_fp fp sel}
              sel_reads_fp fp sel
              <==>
              (forall (h0 h1:imem inv) loc. {:pattern  (B.modifies loc h0 h1); (sel h1)}
                 B.loc_disjoint (as_loc fp) loc /\
                 B.modifies loc h0 h1 ==>
                 sel h0 == sel h1)) /\
            (forall fp inv .{:pattern inv_reads_fp fp inv}
               inv_reads_fp fp inv
               <==>
               (forall h0 h1 loc.{:pattern (B.modifies loc h0 h1); (inv h1)}
                  inv h0 /\
                  B.loc_disjoint (as_loc fp) loc /\
                  B.modifies loc h0 h1 ==>
                  inv h1)))
  = ()

noeq 
type resource : Type u#1 = {
    t: Type u#0;
    view: view t
  }

let as_resource (#a:Type) (view:view a) : resource = {
    t = a;
    view = view
  }

let view_of (res:resource) = 
  res.view

let fp (res:resource) = 
  res.view.fp

let inv (res:resource) (h:HS.mem) =
  res.view.inv h

let sel (#a:Type) (view:view a) (h:imem (inv (as_resource view))) =
  view.sel h

(* (Non-separating) conjunction on views and resources *)

let r_union (res1 res2:resource) : res:resource = 
  let fp = Ghost.hide (B.loc_union (as_loc (fp res1)) (as_loc (fp res2))) in 
  let inv h = inv res1 h /\ inv res2 h in
  let sel h = (sel res1.view h,sel res2.view h) in
  let t = res1.t & res2.t in 
  let view = {
      fp = fp;
      inv = inv;
      sel = sel
    } in 
  {
    t = t;
    view = view
  }

(* Separating conjunction on views and resources *)

unfold
let r_disjoint (res1 res2:resource) = 
  B.loc_disjoint (as_loc (fp res1)) (as_loc (fp res2))

abstract
let ( <*> ) (res1 res2:resource) : res:resource = 
  let fp = Ghost.hide (B.loc_union (as_loc (fp res1)) (as_loc (fp res2))) in 
  let inv h = inv res1 h /\ inv res2 h /\ r_disjoint res1 res2 in
  let sel h = (sel res1.view h,sel res2.view h) in
  let t = res1.t & res2.t in 
  let view = {
      fp = fp;
      inv = inv;
      sel = sel
    } in 
  {
    t = t;
    view = view
  }

let reveal_star_inv (res1 res2:resource) (h:HS.mem)
  : Lemma ((inv (res1 <*> res2) h) 
           <==> 
           (inv res1 h /\ inv res2 h /\ r_disjoint res1 res2))
          [SMTPat (inv (res1 <*> res2) h)] =                    // [DA: we might consider removing this SMTPat 
                                                                //      at the cost of having to have expicitly 
                                                                //      call reveals in specs involving <*>]
  ()

let reveal_star () 
  : Lemma ((forall res1 res2 .{:pattern as_loc (fp (res1 <*> res2))} 
              as_loc (fp (res1 <*> res2)) == B.loc_union (as_loc (fp res1)) (as_loc (fp res2))) /\
           (forall res1 res2 .{:pattern (res1 <*> res2).t} 
              (res1 <*> res2).t == res1.t & res2.t) /\
           (forall res1 res2 h .{:pattern (res1 <*> res2).view.sel h} 
              (res1 <*> res2).view.sel h == (sel res1.view h,sel res2.view h))) = 
  ()

(* Empty resource *)

let empty_resource : resource =
  let t = unit in
  let view = {
      fp = Ghost.hide B.loc_none;
      inv = (fun _ -> True);
      sel = (fun _ -> ())
    } in
  {
    t = t;
    view = view
  }

(* Constructive resource inclusion *)

let r_includes outer inner = 
  delta:resource {
    // Footprint of the outer resource is union of delta and the inner resource
    as_loc (fp outer) == B.loc_union (as_loc (fp delta)) (as_loc (fp inner)) /\
    // Outer invariant is equivalent to delta and the inner invariant (when they are disjoint)
    (forall h . inv outer h <==> inv inner h /\ inv delta h /\ r_disjoint delta inner)
  }

(* Left and right inclusions for separating conjunction *)

let star_includes_left (#res1:resource) (res2:resource)
                     : r_includes (res1 <*> res2) res1 = 
  res2

let star_includes_right (#res1:resource) (res2:resource)
                      : r_includes (res2 <*> res1) res1 = 
  res2

(* Left and right inclusions for the empty resource *)

let star_includes_empty_left (#res:resource)
                           : r_includes res (empty_resource <*> res) =
  empty_resource

let star_includes_empty_right (#res:resource)
                           : r_includes res (res <*> empty_resource) =
  empty_resource

(* Constructive resource inclusion v2 *)

let can_be_split_into (outer:resource) ((inner,delta):resource & resource) = 
    // Footprint of the outer resource is union of delta and the inner resource
    as_loc (fp outer) == B.loc_union (as_loc (fp delta)) (as_loc (fp inner)) /\
    // Outer invariant is equivalent to delta and the inner invariant (when they are disjoint)
    (forall h . inv outer h <==> inv inner h /\ inv delta h /\ r_disjoint delta inner)

(* Left and right inclusions for separating conjunction v2 *)

let star_can_be_split_into_parts (res1 res2:resource)
  : Lemma ((res1 <*> res2) `can_be_split_into` (res1,res2))
          [SMTPat (can_be_split_into (res1 <*> res2) (res1,res2))]= 
  ()

let star_can_be_split_into_parts' (res1 res2:resource)
  : Lemma (can_be_split_into (res1 <*> res2) (res2,res1))
          [SMTPat ((res1 <*> res2) `can_be_split_into` (res2,res1))]= 
  ()








//WIP: Will disappear soon

(* Weaker form of resource inclusion (with invariant inclusion instead of equivalence) *)

let r_weakly_includes outer inner = 
  delta:resource {
    // Delta is disjoint from the inner resource
    r_disjoint delta outer /\
    // Footprint of the outer resource is union of delta and the inner resource
    as_loc (fp outer) == B.loc_union (as_loc (fp delta)) (as_loc (fp inner)) /\
    // Outer invariant (only) implies the delta and the inner invariant
    (forall h . inv outer h ==> inv inner h /\ inv delta h)
  }