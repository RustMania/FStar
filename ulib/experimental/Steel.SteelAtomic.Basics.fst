(*
   Copyright 2020 Microsoft Research

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

module Steel.SteelAtomic.Basics
open Steel.Effect
open Steel.Effect.Atomic
open Steel.Memory
open Steel.Permissions
module Sem = Steel.Semantics.Hoare.MST

let return_atomic (#a:Type) (#uses:Set.set lock_addr) (#p:a -> hprop) (x:a)
: SteelAtomic a uses true (p x) p
= SteelAtomic?.reflect (return a x uses p)

val h_assert_atomic (#uses:Set.set lock_addr) (p:hprop)
  : SteelAtomic unit uses true p (fun _ -> p)
let h_assert_atomic #uses p = steel_assert uses p

val h_intro_emp_l (#uses:Set.set lock_addr) (p:hprop)
  : SteelAtomic unit uses true p (fun _ -> emp `star` p)
let h_intro_emp_l #uses p =
  change_hprop p (emp `star` p) (fun m -> emp_unit p; star_commutative p emp)

val h_elim_emp_l (#uses:Set.set lock_addr) (p:hprop)
  : SteelAtomic unit uses true (emp `star` p) (fun _ -> p)
let h_elim_emp_l #uses p =
  change_hprop (emp `star` p) p (fun m -> emp_unit p; star_commutative p emp)

val h_commute (#uses:Set.set lock_addr) (p q:hprop)
  : SteelAtomic unit uses true (p `star` q) (fun _ -> q `star` p)
let h_commute #uses p q =
   change_hprop (p `star` q) (q `star` p) (fun m -> star_commutative p q)

val h_assoc_left (#uses:Set.set lock_addr) (p q r:hprop)
  : SteelAtomic unit uses true ((p `star` q) `star` r) (fun _ -> p `star` (q `star` r))
let h_assoc_left #uses p q r =
   change_hprop ((p `star` q) `star` r) (p `star` (q `star` r)) (fun m -> star_associative p q r)

val h_assoc_right (#uses:Set.set lock_addr) (p q r:hprop)
  : SteelAtomic unit uses true (p `star` (q `star` r)) (fun _ -> (p `star` q) `star` r)
let h_assoc_right #uses p q r =
   change_hprop (p `star` (q `star` r)) ((p `star` q) `star` r) (fun m -> star_associative p q r)

val intro_h_exists (#a:Type) (#uses:Set.set lock_addr) (x:a) (p:a -> hprop)
  : SteelAtomic unit uses true (p x) (fun _ -> h_exists p)
let intro_h_exists #a #uses x p =
  change_hprop (p x) (h_exists p) (fun m -> intro_exists x p m)

val h_affine (#uses:Set.set lock_addr) (p q:hprop)
  : SteelAtomic unit uses true (p `star` q) (fun _ -> p)
let h_affine #uses p q =
  change_hprop (p `star` q) p (fun m -> affine_star p q m)
