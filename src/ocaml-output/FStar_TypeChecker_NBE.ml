open Prims
let (max : Prims.int -> Prims.int -> Prims.int) =
  fun a -> fun b -> if a > b then a else b
let map_rev : 'a 'b . ('a -> 'b) -> 'a Prims.list -> 'b Prims.list =
  fun f ->
    fun l ->
      let rec aux l1 acc =
        match l1 with
        | [] -> acc
        | x::xs ->
            let uu____71 = let uu____74 = f x in uu____74 :: acc in
            aux xs uu____71 in
      aux l []
let map_rev_append :
  'a 'b . ('a -> 'b) -> 'a Prims.list -> 'b Prims.list -> 'b Prims.list =
  fun f ->
    fun l1 ->
      fun l2 ->
        let rec aux l acc =
          match l with
          | [] -> l2
          | x::xs ->
              let uu____144 = let uu____147 = f x in uu____147 :: acc in
              aux xs uu____144 in
        aux l1 l2
let rec map_append :
  'a 'b . ('a -> 'b) -> 'a Prims.list -> 'b Prims.list -> 'b Prims.list =
  fun f ->
    fun l1 ->
      fun l2 ->
        match l1 with
        | [] -> l2
        | x::xs ->
            let uu____196 = f x in
            let uu____197 = map_append f xs l2 in uu____196 :: uu____197
let rec drop : 'a . ('a -> Prims.bool) -> 'a Prims.list -> 'a Prims.list =
  fun p ->
    fun l ->
      match l with
      | [] -> []
      | x::xs ->
          let uu____233 = p x in if uu____233 then x :: xs else drop p xs
let fmap_opt :
  'a 'b .
    ('a -> 'b) ->
      'a FStar_Pervasives_Native.option -> 'b FStar_Pervasives_Native.option
  =
  fun f ->
    fun x ->
      FStar_Util.bind_opt x
        (fun x1 ->
           let uu____271 = f x1 in FStar_Pervasives_Native.Some uu____271)
let drop_until : 'a . ('a -> Prims.bool) -> 'a Prims.list -> 'a Prims.list =
  fun f ->
    fun l ->
      let rec aux l1 =
        match l1 with
        | [] -> []
        | x::xs -> let uu____318 = f x in if uu____318 then l1 else aux xs in
      aux l
let (trim : Prims.bool Prims.list -> Prims.bool Prims.list) =
  fun l ->
    let uu____335 = drop_until FStar_Pervasives.id (FStar_List.rev l) in
    FStar_List.rev uu____335
let (implies : Prims.bool -> Prims.bool -> Prims.bool) =
  fun b1 ->
    fun b2 ->
      match (b1, b2) with | (false, uu____348) -> true | (true, b21) -> b21
let (let_rec_arity :
  FStar_Syntax_Syntax.letbinding -> (Prims.int * Prims.bool Prims.list)) =
  fun b ->
    let uu____367 = FStar_Syntax_Util.let_rec_arity b in
    match uu____367 with
    | (ar, maybe_lst) ->
        (match maybe_lst with
         | FStar_Pervasives_Native.None ->
             let uu____400 = FStar_Common.tabulate ar (fun uu____404 -> true) in
             (ar, uu____400)
         | FStar_Pervasives_Native.Some lst -> (ar, lst))
let (debug_term : FStar_Syntax_Syntax.term -> unit) =
  fun t ->
    let uu____419 = FStar_Syntax_Print.term_to_string t in
    FStar_Util.print1 "%s\n" uu____419
let (debug_sigmap : FStar_Syntax_Syntax.sigelt FStar_Util.smap -> unit) =
  fun m ->
    FStar_Util.smap_fold m
      (fun k ->
         fun v ->
           fun u ->
             let uu____436 = FStar_Syntax_Print.sigelt_to_string_short v in
             FStar_Util.print2 "%s -> %%s\n" k uu____436) ()
type config =
  {
  core_cfg: FStar_TypeChecker_Cfg.cfg ;
  fv_cache: FStar_TypeChecker_NBETerm.t FStar_Util.smap }
let (__proj__Mkconfig__item__core_cfg : config -> FStar_TypeChecker_Cfg.cfg)
  =
  fun projectee -> match projectee with | { core_cfg; fv_cache;_} -> core_cfg
let (__proj__Mkconfig__item__fv_cache :
  config -> FStar_TypeChecker_NBETerm.t FStar_Util.smap) =
  fun projectee -> match projectee with | { core_cfg; fv_cache;_} -> fv_cache
let (new_config : FStar_TypeChecker_Cfg.cfg -> config) =
  fun cfg ->
    let uu____476 = FStar_Util.smap_create (Prims.of_int (51)) in
    { core_cfg = cfg; fv_cache = uu____476 }
let (reifying_false : config -> config) =
  fun cfg ->
    if (cfg.core_cfg).FStar_TypeChecker_Cfg.reifying
    then
      new_config
        (let uu___92_486 = cfg.core_cfg in
         {
           FStar_TypeChecker_Cfg.steps =
             (uu___92_486.FStar_TypeChecker_Cfg.steps);
           FStar_TypeChecker_Cfg.tcenv =
             (uu___92_486.FStar_TypeChecker_Cfg.tcenv);
           FStar_TypeChecker_Cfg.debug =
             (uu___92_486.FStar_TypeChecker_Cfg.debug);
           FStar_TypeChecker_Cfg.delta_level =
             (uu___92_486.FStar_TypeChecker_Cfg.delta_level);
           FStar_TypeChecker_Cfg.primitive_steps =
             (uu___92_486.FStar_TypeChecker_Cfg.primitive_steps);
           FStar_TypeChecker_Cfg.strong =
             (uu___92_486.FStar_TypeChecker_Cfg.strong);
           FStar_TypeChecker_Cfg.memoize_lazy =
             (uu___92_486.FStar_TypeChecker_Cfg.memoize_lazy);
           FStar_TypeChecker_Cfg.normalize_pure_lets =
             (uu___92_486.FStar_TypeChecker_Cfg.normalize_pure_lets);
           FStar_TypeChecker_Cfg.reifying = false
         })
    else cfg
let (reifying_true : config -> config) =
  fun cfg ->
    if Prims.op_Negation (cfg.core_cfg).FStar_TypeChecker_Cfg.reifying
    then
      new_config
        (let uu___96_495 = cfg.core_cfg in
         {
           FStar_TypeChecker_Cfg.steps =
             (uu___96_495.FStar_TypeChecker_Cfg.steps);
           FStar_TypeChecker_Cfg.tcenv =
             (uu___96_495.FStar_TypeChecker_Cfg.tcenv);
           FStar_TypeChecker_Cfg.debug =
             (uu___96_495.FStar_TypeChecker_Cfg.debug);
           FStar_TypeChecker_Cfg.delta_level =
             (uu___96_495.FStar_TypeChecker_Cfg.delta_level);
           FStar_TypeChecker_Cfg.primitive_steps =
             (uu___96_495.FStar_TypeChecker_Cfg.primitive_steps);
           FStar_TypeChecker_Cfg.strong =
             (uu___96_495.FStar_TypeChecker_Cfg.strong);
           FStar_TypeChecker_Cfg.memoize_lazy =
             (uu___96_495.FStar_TypeChecker_Cfg.memoize_lazy);
           FStar_TypeChecker_Cfg.normalize_pure_lets =
             (uu___96_495.FStar_TypeChecker_Cfg.normalize_pure_lets);
           FStar_TypeChecker_Cfg.reifying = true
         })
    else cfg
let (zeta_false : config -> config) =
  fun cfg ->
    let cfg_core = cfg.core_cfg in
    if (cfg_core.FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.zeta
    then
      let cfg_core' =
        let uu___101_504 = cfg_core in
        {
          FStar_TypeChecker_Cfg.steps =
            (let uu___103_507 = cfg_core.FStar_TypeChecker_Cfg.steps in
             {
               FStar_TypeChecker_Cfg.beta =
                 (uu___103_507.FStar_TypeChecker_Cfg.beta);
               FStar_TypeChecker_Cfg.iota =
                 (uu___103_507.FStar_TypeChecker_Cfg.iota);
               FStar_TypeChecker_Cfg.zeta = false;
               FStar_TypeChecker_Cfg.zeta_full =
                 (uu___103_507.FStar_TypeChecker_Cfg.zeta_full);
               FStar_TypeChecker_Cfg.weak =
                 (uu___103_507.FStar_TypeChecker_Cfg.weak);
               FStar_TypeChecker_Cfg.hnf =
                 (uu___103_507.FStar_TypeChecker_Cfg.hnf);
               FStar_TypeChecker_Cfg.primops =
                 (uu___103_507.FStar_TypeChecker_Cfg.primops);
               FStar_TypeChecker_Cfg.do_not_unfold_pure_lets =
                 (uu___103_507.FStar_TypeChecker_Cfg.do_not_unfold_pure_lets);
               FStar_TypeChecker_Cfg.unfold_until =
                 (uu___103_507.FStar_TypeChecker_Cfg.unfold_until);
               FStar_TypeChecker_Cfg.unfold_only =
                 (uu___103_507.FStar_TypeChecker_Cfg.unfold_only);
               FStar_TypeChecker_Cfg.unfold_fully =
                 (uu___103_507.FStar_TypeChecker_Cfg.unfold_fully);
               FStar_TypeChecker_Cfg.unfold_attr =
                 (uu___103_507.FStar_TypeChecker_Cfg.unfold_attr);
               FStar_TypeChecker_Cfg.unfold_tac =
                 (uu___103_507.FStar_TypeChecker_Cfg.unfold_tac);
               FStar_TypeChecker_Cfg.pure_subterms_within_computations =
                 (uu___103_507.FStar_TypeChecker_Cfg.pure_subterms_within_computations);
               FStar_TypeChecker_Cfg.simplify =
                 (uu___103_507.FStar_TypeChecker_Cfg.simplify);
               FStar_TypeChecker_Cfg.erase_universes =
                 (uu___103_507.FStar_TypeChecker_Cfg.erase_universes);
               FStar_TypeChecker_Cfg.allow_unbound_universes =
                 (uu___103_507.FStar_TypeChecker_Cfg.allow_unbound_universes);
               FStar_TypeChecker_Cfg.reify_ =
                 (uu___103_507.FStar_TypeChecker_Cfg.reify_);
               FStar_TypeChecker_Cfg.compress_uvars =
                 (uu___103_507.FStar_TypeChecker_Cfg.compress_uvars);
               FStar_TypeChecker_Cfg.no_full_norm =
                 (uu___103_507.FStar_TypeChecker_Cfg.no_full_norm);
               FStar_TypeChecker_Cfg.check_no_uvars =
                 (uu___103_507.FStar_TypeChecker_Cfg.check_no_uvars);
               FStar_TypeChecker_Cfg.unmeta =
                 (uu___103_507.FStar_TypeChecker_Cfg.unmeta);
               FStar_TypeChecker_Cfg.unascribe =
                 (uu___103_507.FStar_TypeChecker_Cfg.unascribe);
               FStar_TypeChecker_Cfg.in_full_norm_request =
                 (uu___103_507.FStar_TypeChecker_Cfg.in_full_norm_request);
               FStar_TypeChecker_Cfg.weakly_reduce_scrutinee =
                 (uu___103_507.FStar_TypeChecker_Cfg.weakly_reduce_scrutinee);
               FStar_TypeChecker_Cfg.nbe_step =
                 (uu___103_507.FStar_TypeChecker_Cfg.nbe_step);
               FStar_TypeChecker_Cfg.for_extraction =
                 (uu___103_507.FStar_TypeChecker_Cfg.for_extraction)
             });
          FStar_TypeChecker_Cfg.tcenv =
            (uu___101_504.FStar_TypeChecker_Cfg.tcenv);
          FStar_TypeChecker_Cfg.debug =
            (uu___101_504.FStar_TypeChecker_Cfg.debug);
          FStar_TypeChecker_Cfg.delta_level =
            (uu___101_504.FStar_TypeChecker_Cfg.delta_level);
          FStar_TypeChecker_Cfg.primitive_steps =
            (uu___101_504.FStar_TypeChecker_Cfg.primitive_steps);
          FStar_TypeChecker_Cfg.strong =
            (uu___101_504.FStar_TypeChecker_Cfg.strong);
          FStar_TypeChecker_Cfg.memoize_lazy =
            (uu___101_504.FStar_TypeChecker_Cfg.memoize_lazy);
          FStar_TypeChecker_Cfg.normalize_pure_lets =
            (uu___101_504.FStar_TypeChecker_Cfg.normalize_pure_lets);
          FStar_TypeChecker_Cfg.reifying =
            (uu___101_504.FStar_TypeChecker_Cfg.reifying)
        } in
      new_config cfg_core'
    else cfg
let (cache_add :
  config -> FStar_Syntax_Syntax.fv -> FStar_TypeChecker_NBETerm.t -> unit) =
  fun cfg ->
    fun fv ->
      fun v ->
        let lid = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
        let uu____525 = FStar_Ident.string_of_lid lid in
        FStar_Util.smap_add cfg.fv_cache uu____525 v
let (try_in_cache :
  config ->
    FStar_Syntax_Syntax.fv ->
      FStar_TypeChecker_NBETerm.t FStar_Pervasives_Native.option)
  =
  fun cfg ->
    fun fv ->
      let lid = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
      let uu____541 = FStar_Ident.string_of_lid lid in
      FStar_Util.smap_try_find cfg.fv_cache uu____541
let (debug : config -> (unit -> unit) -> unit) =
  fun cfg -> fun f -> FStar_TypeChecker_Cfg.log_nbe cfg.core_cfg f
let rec (unlazy_unmeta :
  FStar_TypeChecker_NBETerm.t -> FStar_TypeChecker_NBETerm.t) =
  fun t ->
    match t.FStar_TypeChecker_NBETerm.nbe_t with
    | FStar_TypeChecker_NBETerm.Lazy (uu____562, t1) ->
        let uu____584 = FStar_Thunk.force t1 in unlazy_unmeta uu____584
    | FStar_TypeChecker_NBETerm.Meta (t0, m) ->
        let uu____591 = FStar_Thunk.force m in
        (match uu____591 with
         | FStar_Syntax_Syntax.Meta_monadic (uu____592, uu____593) -> t
         | FStar_Syntax_Syntax.Meta_monadic_lift
             (uu____598, uu____599, uu____600) -> t
         | uu____605 -> unlazy_unmeta t0)
    | uu____606 -> t
let (pickBranch :
  config ->
    FStar_TypeChecker_NBETerm.t ->
      FStar_Syntax_Syntax.branch Prims.list ->
        (FStar_Syntax_Syntax.term * FStar_TypeChecker_NBETerm.t Prims.list)
          FStar_Pervasives_Native.option)
  =
  fun cfg ->
    fun scrut ->
      fun branches ->
        let all_branches = branches in
        let rec pickBranch_aux scrut1 branches1 branches0 =
          let rec matches_pat scrutinee0 p =
            debug cfg
              (fun uu____712 ->
                 let uu____713 =
                   FStar_TypeChecker_NBETerm.t_to_string scrutinee0 in
                 let uu____714 = FStar_Syntax_Print.pat_to_string p in
                 FStar_Util.print2 "matches_pat (%s, %s)\n" uu____713
                   uu____714);
            (let scrutinee = unlazy_unmeta scrutinee0 in
             let r =
               match p.FStar_Syntax_Syntax.v with
               | FStar_Syntax_Syntax.Pat_var bv ->
                   FStar_Util.Inl [scrutinee0]
               | FStar_Syntax_Syntax.Pat_wild bv ->
                   FStar_Util.Inl [scrutinee0]
               | FStar_Syntax_Syntax.Pat_dot_term uu____735 ->
                   FStar_Util.Inl []
               | FStar_Syntax_Syntax.Pat_constant s ->
                   let matches_const c s1 =
                     debug cfg
                       (fun uu____760 ->
                          let uu____761 =
                            FStar_TypeChecker_NBETerm.t_to_string c in
                          let uu____762 =
                            FStar_Syntax_Print.const_to_string s1 in
                          FStar_Util.print2
                            "Testing term %s against pattern %s\n" uu____761
                            uu____762);
                     (match c.FStar_TypeChecker_NBETerm.nbe_t with
                      | FStar_TypeChecker_NBETerm.Constant
                          (FStar_TypeChecker_NBETerm.Unit) ->
                          s1 = FStar_Const.Const_unit
                      | FStar_TypeChecker_NBETerm.Constant
                          (FStar_TypeChecker_NBETerm.Bool b) ->
                          (match s1 with
                           | FStar_Const.Const_bool p1 -> b = p1
                           | uu____765 -> false)
                      | FStar_TypeChecker_NBETerm.Constant
                          (FStar_TypeChecker_NBETerm.Int i) ->
                          (match s1 with
                           | FStar_Const.Const_int
                               (p1, FStar_Pervasives_Native.None) ->
                               let uu____778 =
                                 FStar_BigInt.big_int_of_string p1 in
                               i = uu____778
                           | uu____779 -> false)
                      | FStar_TypeChecker_NBETerm.Constant
                          (FStar_TypeChecker_NBETerm.String (st, uu____781))
                          ->
                          (match s1 with
                           | FStar_Const.Const_string (p1, uu____783) ->
                               st = p1
                           | uu____784 -> false)
                      | FStar_TypeChecker_NBETerm.Constant
                          (FStar_TypeChecker_NBETerm.Char c1) ->
                          (match s1 with
                           | FStar_Const.Const_char p1 -> c1 = p1
                           | uu____787 -> false)
                      | uu____788 -> false) in
                   let uu____789 = matches_const scrutinee s in
                   if uu____789
                   then FStar_Util.Inl []
                   else FStar_Util.Inr false
               | FStar_Syntax_Syntax.Pat_cons (fv, arg_pats) ->
                   let rec matches_args out a p1 =
                     match (a, p1) with
                     | ([], []) -> FStar_Util.Inl out
                     | ((t, uu____910)::rest_a, (p2, uu____913)::rest_p) ->
                         let uu____947 = matches_pat t p2 in
                         (match uu____947 with
                          | FStar_Util.Inl s ->
                              matches_args (FStar_List.append out s) rest_a
                                rest_p
                          | m -> m)
                     | uu____972 -> FStar_Util.Inr false in
                   (match scrutinee.FStar_TypeChecker_NBETerm.nbe_t with
                    | FStar_TypeChecker_NBETerm.Construct
                        (fv', _us, args_rev) ->
                        let uu____1016 = FStar_Syntax_Syntax.fv_eq fv fv' in
                        if uu____1016
                        then
                          matches_args [] (FStar_List.rev args_rev) arg_pats
                        else FStar_Util.Inr false
                    | uu____1030 -> FStar_Util.Inr true) in
             let res_to_string uu___0_1044 =
               match uu___0_1044 with
               | FStar_Util.Inr b ->
                   let uu____1054 = FStar_Util.string_of_bool b in
                   Prims.op_Hat "Inr " uu____1054
               | FStar_Util.Inl bs ->
                   let uu____1060 =
                     FStar_Util.string_of_int (FStar_List.length bs) in
                   Prims.op_Hat "Inl " uu____1060 in
             debug cfg
               (fun uu____1066 ->
                  let uu____1067 =
                    FStar_TypeChecker_NBETerm.t_to_string scrutinee in
                  let uu____1068 = FStar_Syntax_Print.pat_to_string p in
                  let uu____1069 = res_to_string r in
                  FStar_Util.print3 "matches_pat (%s, %s) = %s\n" uu____1067
                    uu____1068 uu____1069);
             r) in
          match branches1 with
          | [] -> FStar_Pervasives_Native.None
          | (p, _wopt, e)::branches2 ->
              let uu____1106 = matches_pat scrut1 p in
              (match uu____1106 with
               | FStar_Util.Inl matches ->
                   (debug cfg
                      (fun uu____1129 ->
                         let uu____1130 = FStar_Syntax_Print.pat_to_string p in
                         FStar_Util.print1 "Pattern %s matches\n" uu____1130);
                    FStar_Pervasives_Native.Some (e, matches))
               | FStar_Util.Inr (false) ->
                   pickBranch_aux scrut1 branches2 branches0
               | FStar_Util.Inr (true) -> FStar_Pervasives_Native.None) in
        pickBranch_aux scrut branches branches
let (should_reduce_recursive_definition :
  FStar_TypeChecker_NBETerm.args ->
    Prims.bool Prims.list ->
      (Prims.bool * FStar_TypeChecker_NBETerm.args *
        FStar_TypeChecker_NBETerm.args))
  =
  fun arguments ->
    fun formals_in_decreases ->
      let rec aux ts ar_list acc =
        match (ts, ar_list) with
        | (uu____1263, []) -> (true, acc, ts)
        | ([], uu____1290::uu____1291) -> (false, acc, [])
        | (t::ts1, in_decreases_clause::bs) ->
            let uu____1350 =
              in_decreases_clause &&
                (FStar_TypeChecker_NBETerm.isAccu
                   (FStar_Pervasives_Native.fst t)) in
            if uu____1350
            then (false, (FStar_List.rev_append ts1 acc), [])
            else aux ts1 bs (t :: acc) in
      aux arguments formals_in_decreases []
let (find_sigelt_in_gamma :
  config ->
    FStar_TypeChecker_Env.env ->
      FStar_Ident.lident ->
        FStar_Syntax_Syntax.sigelt FStar_Pervasives_Native.option)
  =
  fun cfg ->
    fun env ->
      fun lid ->
        let mapper uu____1442 =
          match uu____1442 with
          | (lr, rng) ->
              (match lr with
               | FStar_Util.Inr (elt, FStar_Pervasives_Native.None) ->
                   FStar_Pervasives_Native.Some elt
               | FStar_Util.Inr (elt, FStar_Pervasives_Native.Some us) ->
                   (debug cfg
                      (fun uu____1525 ->
                         let uu____1526 =
                           FStar_Syntax_Print.univs_to_string us in
                         FStar_Util.print1
                           "Universes in local declaration: %s\n" uu____1526);
                    FStar_Pervasives_Native.Some elt)
               | uu____1527 -> FStar_Pervasives_Native.None) in
        let uu____1542 = FStar_TypeChecker_Env.lookup_qname env lid in
        FStar_Util.bind_opt uu____1542 mapper
let (is_univ : FStar_TypeChecker_NBETerm.t -> Prims.bool) =
  fun tm ->
    match tm.FStar_TypeChecker_NBETerm.nbe_t with
    | FStar_TypeChecker_NBETerm.Univ uu____1586 -> true
    | uu____1587 -> false
let (un_univ : FStar_TypeChecker_NBETerm.t -> FStar_Syntax_Syntax.universe) =
  fun tm ->
    match tm.FStar_TypeChecker_NBETerm.nbe_t with
    | FStar_TypeChecker_NBETerm.Univ u -> u
    | uu____1594 ->
        let uu____1595 =
          let uu____1596 = FStar_TypeChecker_NBETerm.t_to_string tm in
          Prims.op_Hat "Not a universe: " uu____1596 in
        failwith uu____1595
let (is_constr_fv : FStar_Syntax_Syntax.fv -> Prims.bool) =
  fun fvar ->
    fvar.FStar_Syntax_Syntax.fv_qual =
      (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor)
let (is_constr : FStar_TypeChecker_Env.qninfo -> Prims.bool) =
  fun q ->
    match q with
    | FStar_Pervasives_Native.Some
        (FStar_Util.Inr
         ({
            FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_datacon
              (uu____1609, uu____1610, uu____1611, uu____1612, uu____1613,
               uu____1614);
            FStar_Syntax_Syntax.sigrng = uu____1615;
            FStar_Syntax_Syntax.sigquals = uu____1616;
            FStar_Syntax_Syntax.sigmeta = uu____1617;
            FStar_Syntax_Syntax.sigattrs = uu____1618;
            FStar_Syntax_Syntax.sigopts = uu____1619;_},
          uu____1620),
         uu____1621)
        -> true
    | uu____1678 -> false
let (translate_univ :
  config ->
    FStar_TypeChecker_NBETerm.t Prims.list ->
      FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe)
  =
  fun cfg ->
    fun bs ->
      fun u ->
        let rec aux u1 =
          let u2 = FStar_Syntax_Subst.compress_univ u1 in
          match u2 with
          | FStar_Syntax_Syntax.U_bvar i ->
              if i < (FStar_List.length bs)
              then let u' = FStar_List.nth bs i in un_univ u'
              else
                if
                  ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.allow_unbound_universes
                then FStar_Syntax_Syntax.U_zero
                else failwith "Universe index out of bounds"
          | FStar_Syntax_Syntax.U_succ u3 ->
              let uu____1710 = aux u3 in
              FStar_Syntax_Syntax.U_succ uu____1710
          | FStar_Syntax_Syntax.U_max us ->
              let uu____1714 = FStar_List.map aux us in
              FStar_Syntax_Syntax.U_max uu____1714
          | FStar_Syntax_Syntax.U_unknown -> u2
          | FStar_Syntax_Syntax.U_name uu____1717 -> u2
          | FStar_Syntax_Syntax.U_unif uu____1718 -> u2
          | FStar_Syntax_Syntax.U_zero -> u2 in
        aux u
let (find_let :
  FStar_Syntax_Syntax.letbinding Prims.list ->
    FStar_Syntax_Syntax.fv ->
      FStar_Syntax_Syntax.letbinding FStar_Pervasives_Native.option)
  =
  fun lbs ->
    fun fvar ->
      FStar_Util.find_map lbs
        (fun lb ->
           match lb.FStar_Syntax_Syntax.lbname with
           | FStar_Util.Inl uu____1750 -> failwith "find_let : impossible"
           | FStar_Util.Inr name ->
               let uu____1754 = FStar_Syntax_Syntax.fv_eq name fvar in
               if uu____1754
               then FStar_Pervasives_Native.Some lb
               else FStar_Pervasives_Native.None)
let (mk_rt :
  FStar_Range.range ->
    FStar_TypeChecker_NBETerm.t' -> FStar_TypeChecker_NBETerm.t)
  =
  fun r ->
    fun t ->
      {
        FStar_TypeChecker_NBETerm.nbe_t = t;
        FStar_TypeChecker_NBETerm.nbe_r = r
      }
let (mk_t : FStar_TypeChecker_NBETerm.t' -> FStar_TypeChecker_NBETerm.t) =
  fun t ->
    {
      FStar_TypeChecker_NBETerm.nbe_t = t;
      FStar_TypeChecker_NBETerm.nbe_r = FStar_Range.dummyRange
    }
let rec (translate :
  config ->
    FStar_TypeChecker_NBETerm.t Prims.list ->
      FStar_Syntax_Syntax.term -> FStar_TypeChecker_NBETerm.t)
  =
  fun cfg ->
    fun bs ->
      fun e ->
        let debug1 = debug cfg in
        let mk_t1 t = mk_rt e.FStar_Syntax_Syntax.pos t in
        debug1
          (fun uu____2041 ->
             let uu____2042 =
               let uu____2043 = FStar_Syntax_Subst.compress e in
               FStar_Syntax_Print.tag_of_term uu____2043 in
             let uu____2044 =
               let uu____2045 = FStar_Syntax_Subst.compress e in
               FStar_Syntax_Print.term_to_string uu____2045 in
             FStar_Util.print2 "Term: %s - %s\n" uu____2042 uu____2044);
        (let uu____2046 =
           let uu____2047 = FStar_Syntax_Subst.compress e in
           uu____2047.FStar_Syntax_Syntax.n in
         match uu____2046 with
         | FStar_Syntax_Syntax.Tm_delayed (uu____2050, uu____2051) ->
             failwith "Tm_delayed: Impossible"
         | FStar_Syntax_Syntax.Tm_unknown ->
             mk_t1 FStar_TypeChecker_NBETerm.Unknown
         | FStar_Syntax_Syntax.Tm_constant c ->
             let uu____2073 =
               let uu____2074 = translate_constant c in
               FStar_TypeChecker_NBETerm.Constant uu____2074 in
             FStar_All.pipe_left mk_t1 uu____2073
         | FStar_Syntax_Syntax.Tm_bvar db ->
             if db.FStar_Syntax_Syntax.index < (FStar_List.length bs)
             then
               let t = FStar_List.nth bs db.FStar_Syntax_Syntax.index in
               (debug1
                  (fun uu____2084 ->
                     let uu____2085 = FStar_TypeChecker_NBETerm.t_to_string t in
                     let uu____2086 =
                       let uu____2087 =
                         FStar_List.map FStar_TypeChecker_NBETerm.t_to_string
                           bs in
                       FStar_All.pipe_right uu____2087
                         (FStar_String.concat "; ") in
                     FStar_Util.print2
                       "Resolved bvar to %s\n\tcontext is [%s]\n" uu____2085
                       uu____2086);
                t)
             else failwith "de Bruijn index out of bounds"
         | FStar_Syntax_Syntax.Tm_uinst (t, us) ->
             (debug1
                (fun uu____2106 ->
                   let uu____2107 = FStar_Syntax_Print.term_to_string t in
                   let uu____2108 =
                     let uu____2109 =
                       FStar_List.map FStar_Syntax_Print.univ_to_string us in
                     FStar_All.pipe_right uu____2109
                       (FStar_String.concat ", ") in
                   FStar_Util.print2 "Uinst term : %s\nUnivs : %s\n"
                     uu____2107 uu____2108);
              (let uu____2114 = translate cfg bs t in
               let uu____2115 =
                 FStar_List.map
                   (fun x ->
                      let uu____2119 =
                        let uu____2120 =
                          let uu____2121 = translate_univ cfg bs x in
                          FStar_TypeChecker_NBETerm.Univ uu____2121 in
                        FStar_All.pipe_left mk_t1 uu____2120 in
                      FStar_TypeChecker_NBETerm.as_arg uu____2119) us in
               iapp cfg uu____2114 uu____2115))
         | FStar_Syntax_Syntax.Tm_type u ->
             let uu____2123 =
               let uu____2124 = translate_univ cfg bs u in
               FStar_TypeChecker_NBETerm.Type_t uu____2124 in
             FStar_All.pipe_left mk_t1 uu____2123
         | FStar_Syntax_Syntax.Tm_arrow (xs, c) ->
             let norm uu____2154 =
               let uu____2155 =
                 FStar_List.fold_left
                   (fun uu____2199 ->
                      fun uu____2200 ->
                        match (uu____2199, uu____2200) with
                        | ((ctx, binders_rev), (x, q)) ->
                            let t =
                              let uu____2304 =
                                translate cfg ctx x.FStar_Syntax_Syntax.sort in
                              readback cfg uu____2304 in
                            let x1 =
                              let uu___399_2306 =
                                FStar_Syntax_Syntax.freshen_bv x in
                              {
                                FStar_Syntax_Syntax.ppname =
                                  (uu___399_2306.FStar_Syntax_Syntax.ppname);
                                FStar_Syntax_Syntax.index =
                                  (uu___399_2306.FStar_Syntax_Syntax.index);
                                FStar_Syntax_Syntax.sort = t
                              } in
                            let ctx1 =
                              let uu____2310 =
                                FStar_TypeChecker_NBETerm.mkAccuVar x1 in
                              uu____2310 :: ctx in
                            (ctx1, ((x1, q) :: binders_rev))) (bs, []) xs in
               match uu____2155 with
               | (ctx, binders_rev) ->
                   let c1 =
                     let uu____2370 = translate_comp cfg ctx c in
                     readback_comp cfg uu____2370 in
                   FStar_Syntax_Util.arrow (FStar_List.rev binders_rev) c1 in
             let uu____2377 =
               let uu____2378 =
                 let uu____2395 = FStar_Thunk.mk norm in
                 FStar_Util.Inl uu____2395 in
               FStar_TypeChecker_NBETerm.Arrow uu____2378 in
             FStar_All.pipe_left mk_t1 uu____2377
         | FStar_Syntax_Syntax.Tm_refine (bv, tm) ->
             if
               ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.for_extraction
             then translate cfg bs bv.FStar_Syntax_Syntax.sort
             else
               FStar_All.pipe_left mk_t1
                 (FStar_TypeChecker_NBETerm.Refinement
                    ((fun y -> translate cfg (y :: bs) tm),
                      (fun uu____2431 ->
                         let uu____2432 =
                           translate cfg bs bv.FStar_Syntax_Syntax.sort in
                         FStar_TypeChecker_NBETerm.as_arg uu____2432)))
         | FStar_Syntax_Syntax.Tm_ascribed (t, uu____2434, uu____2435) ->
             translate cfg bs t
         | FStar_Syntax_Syntax.Tm_uvar (u, (subst, set_use_range)) ->
             let norm_uvar uu____2502 =
               let norm_subst_elt uu___1_2508 =
                 match uu___1_2508 with
                 | FStar_Syntax_Syntax.NT (x, t) ->
                     let uu____2515 =
                       let uu____2522 =
                         let uu____2525 = translate cfg bs t in
                         readback cfg uu____2525 in
                       (x, uu____2522) in
                     FStar_Syntax_Syntax.NT uu____2515
                 | FStar_Syntax_Syntax.NM (x, i) ->
                     let x_i =
                       FStar_Syntax_Syntax.bv_to_tm
                         (let uu___436_2533 = x in
                          {
                            FStar_Syntax_Syntax.ppname =
                              (uu___436_2533.FStar_Syntax_Syntax.ppname);
                            FStar_Syntax_Syntax.index = i;
                            FStar_Syntax_Syntax.sort =
                              (uu___436_2533.FStar_Syntax_Syntax.sort)
                          }) in
                     let t =
                       let uu____2535 = translate cfg bs x_i in
                       readback cfg uu____2535 in
                     (match t.FStar_Syntax_Syntax.n with
                      | FStar_Syntax_Syntax.Tm_bvar x_j ->
                          FStar_Syntax_Syntax.NM
                            (x, (x_j.FStar_Syntax_Syntax.index))
                      | uu____2537 -> FStar_Syntax_Syntax.NT (x, t))
                 | uu____2540 ->
                     failwith "Impossible: subst invariant of uvar nodes" in
               let subst1 =
                 FStar_List.map (FStar_List.map norm_subst_elt) subst in
               let uu___446_2550 = e in
               {
                 FStar_Syntax_Syntax.n =
                   (FStar_Syntax_Syntax.Tm_uvar (u, (subst1, set_use_range)));
                 FStar_Syntax_Syntax.pos =
                   (uu___446_2550.FStar_Syntax_Syntax.pos);
                 FStar_Syntax_Syntax.vars =
                   (uu___446_2550.FStar_Syntax_Syntax.vars)
               } in
             let uu____2563 =
               let uu____2564 =
                 let uu____2575 =
                   let uu____2576 = FStar_Thunk.mk norm_uvar in
                   FStar_TypeChecker_NBETerm.UVar uu____2576 in
                 (uu____2575, []) in
               FStar_TypeChecker_NBETerm.Accu uu____2564 in
             FStar_All.pipe_left mk_t1 uu____2563
         | FStar_Syntax_Syntax.Tm_name x ->
             FStar_TypeChecker_NBETerm.mkAccuVar x
         | FStar_Syntax_Syntax.Tm_abs ([], uu____2590, uu____2591) ->
             failwith "Impossible: abstraction with no binders"
         | FStar_Syntax_Syntax.Tm_abs (xs, body, resc) ->
             FStar_All.pipe_left mk_t1
               (FStar_TypeChecker_NBETerm.Lam
                  ((fun ys -> translate cfg (FStar_List.append ys bs) body),
                    (FStar_Util.Inl (bs, xs, resc)), (FStar_List.length xs)))
         | FStar_Syntax_Syntax.Tm_fvar fvar ->
             let uu____2697 = try_in_cache cfg fvar in
             (match uu____2697 with
              | FStar_Pervasives_Native.Some t -> t
              | uu____2701 ->
                  let uu____2704 =
                    FStar_Syntax_Syntax.set_range_of_fv fvar
                      e.FStar_Syntax_Syntax.pos in
                  translate_fv cfg bs uu____2704)
         | FStar_Syntax_Syntax.Tm_app
             ({
                FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_constant
                  (FStar_Const.Const_reify);
                FStar_Syntax_Syntax.pos = uu____2705;
                FStar_Syntax_Syntax.vars = uu____2706;_},
              arg::more::args)
             ->
             let uu____2766 = FStar_Syntax_Util.head_and_args e in
             (match uu____2766 with
              | (head, uu____2784) ->
                  let head1 =
                    FStar_Syntax_Syntax.mk_Tm_app head [arg]
                      e.FStar_Syntax_Syntax.pos in
                  let uu____2826 =
                    FStar_Syntax_Syntax.mk_Tm_app head1 (more :: args)
                      e.FStar_Syntax_Syntax.pos in
                  translate cfg bs uu____2826)
         | FStar_Syntax_Syntax.Tm_app
             ({
                FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_constant
                  (FStar_Const.Const_reflect uu____2835);
                FStar_Syntax_Syntax.pos = uu____2836;
                FStar_Syntax_Syntax.vars = uu____2837;_},
              arg::more::args)
             ->
             let uu____2897 = FStar_Syntax_Util.head_and_args e in
             (match uu____2897 with
              | (head, uu____2915) ->
                  let head1 =
                    FStar_Syntax_Syntax.mk_Tm_app head [arg]
                      e.FStar_Syntax_Syntax.pos in
                  let uu____2957 =
                    FStar_Syntax_Syntax.mk_Tm_app head1 (more :: args)
                      e.FStar_Syntax_Syntax.pos in
                  translate cfg bs uu____2957)
         | FStar_Syntax_Syntax.Tm_app
             ({
                FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_constant
                  (FStar_Const.Const_reflect uu____2966);
                FStar_Syntax_Syntax.pos = uu____2967;
                FStar_Syntax_Syntax.vars = uu____2968;_},
              arg::[])
             when (cfg.core_cfg).FStar_TypeChecker_Cfg.reifying ->
             let cfg1 = reifying_false cfg in
             translate cfg1 bs (FStar_Pervasives_Native.fst arg)
         | FStar_Syntax_Syntax.Tm_app
             ({
                FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_constant
                  (FStar_Const.Const_reflect uu____3013);
                FStar_Syntax_Syntax.pos = uu____3014;
                FStar_Syntax_Syntax.vars = uu____3015;_},
              arg::[])
             ->
             let uu____3055 =
               let uu____3056 =
                 translate cfg bs (FStar_Pervasives_Native.fst arg) in
               FStar_TypeChecker_NBETerm.Reflect uu____3056 in
             FStar_All.pipe_left mk_t1 uu____3055
         | FStar_Syntax_Syntax.Tm_app
             ({
                FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_constant
                  (FStar_Const.Const_reify);
                FStar_Syntax_Syntax.pos = uu____3061;
                FStar_Syntax_Syntax.vars = uu____3062;_},
              arg::[])
             when
             ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.reify_
             ->
             let cfg1 = reifying_true cfg in
             translate cfg1 bs (FStar_Pervasives_Native.fst arg)
         | FStar_Syntax_Syntax.Tm_app (head, args) ->
             (debug1
                (fun uu____3141 ->
                   let uu____3142 = FStar_Syntax_Print.term_to_string head in
                   let uu____3143 = FStar_Syntax_Print.args_to_string args in
                   FStar_Util.print2 "Application: %s @ %s\n" uu____3142
                     uu____3143);
              (let uu____3144 = translate cfg bs head in
               let uu____3145 =
                 FStar_List.map
                   (fun x ->
                      let uu____3167 =
                        translate cfg bs (FStar_Pervasives_Native.fst x) in
                      (uu____3167, (FStar_Pervasives_Native.snd x))) args in
               iapp cfg uu____3144 uu____3145))
         | FStar_Syntax_Syntax.Tm_match (scrut, branches) ->
             let make_branches uu____3219 =
               let cfg1 = zeta_false cfg in
               let rec process_pattern bs1 p =
                 let uu____3250 =
                   match p.FStar_Syntax_Syntax.v with
                   | FStar_Syntax_Syntax.Pat_constant c ->
                       (bs1, (FStar_Syntax_Syntax.Pat_constant c))
                   | FStar_Syntax_Syntax.Pat_cons (fvar, args) ->
                       let uu____3284 =
                         FStar_List.fold_left
                           (fun uu____3322 ->
                              fun uu____3323 ->
                                match (uu____3322, uu____3323) with
                                | ((bs2, args1), (arg, b)) ->
                                    let uu____3404 = process_pattern bs2 arg in
                                    (match uu____3404 with
                                     | (bs', arg') ->
                                         (bs', ((arg', b) :: args1))))
                           (bs1, []) args in
                       (match uu____3284 with
                        | (bs', args') ->
                            (bs',
                              (FStar_Syntax_Syntax.Pat_cons
                                 (fvar, (FStar_List.rev args')))))
                   | FStar_Syntax_Syntax.Pat_var bvar ->
                       let x =
                         let uu____3493 =
                           let uu____3494 =
                             translate cfg1 bs1 bvar.FStar_Syntax_Syntax.sort in
                           readback cfg1 uu____3494 in
                         FStar_Syntax_Syntax.new_bv
                           FStar_Pervasives_Native.None uu____3493 in
                       let uu____3495 =
                         let uu____3498 =
                           FStar_TypeChecker_NBETerm.mkAccuVar x in
                         uu____3498 :: bs1 in
                       (uu____3495, (FStar_Syntax_Syntax.Pat_var x))
                   | FStar_Syntax_Syntax.Pat_wild bvar ->
                       let x =
                         let uu____3503 =
                           let uu____3504 =
                             translate cfg1 bs1 bvar.FStar_Syntax_Syntax.sort in
                           readback cfg1 uu____3504 in
                         FStar_Syntax_Syntax.new_bv
                           FStar_Pervasives_Native.None uu____3503 in
                       let uu____3505 =
                         let uu____3508 =
                           FStar_TypeChecker_NBETerm.mkAccuVar x in
                         uu____3508 :: bs1 in
                       (uu____3505, (FStar_Syntax_Syntax.Pat_wild x))
                   | FStar_Syntax_Syntax.Pat_dot_term (bvar, tm) ->
                       let x =
                         let uu____3518 =
                           let uu____3519 =
                             translate cfg1 bs1 bvar.FStar_Syntax_Syntax.sort in
                           readback cfg1 uu____3519 in
                         FStar_Syntax_Syntax.new_bv
                           FStar_Pervasives_Native.None uu____3518 in
                       let uu____3520 =
                         let uu____3521 =
                           let uu____3528 =
                             let uu____3531 = translate cfg1 bs1 tm in
                             readback cfg1 uu____3531 in
                           (x, uu____3528) in
                         FStar_Syntax_Syntax.Pat_dot_term uu____3521 in
                       (bs1, uu____3520) in
                 match uu____3250 with
                 | (bs2, p_new) ->
                     (bs2,
                       (let uu___573_3551 = p in
                        {
                          FStar_Syntax_Syntax.v = p_new;
                          FStar_Syntax_Syntax.p =
                            (uu___573_3551.FStar_Syntax_Syntax.p)
                        })) in
               FStar_List.map
                 (fun uu____3570 ->
                    match uu____3570 with
                    | (pat, when_clause, e1) ->
                        let uu____3592 = process_pattern bs pat in
                        (match uu____3592 with
                         | (bs', pat') ->
                             let uu____3605 =
                               let uu____3606 =
                                 let uu____3609 = translate cfg1 bs' e1 in
                                 readback cfg1 uu____3609 in
                               (pat', when_clause, uu____3606) in
                             FStar_Syntax_Util.branch uu____3605)) branches in
             let scrut1 = translate cfg bs scrut in
             (debug1
                (fun uu____3626 ->
                   let uu____3627 =
                     FStar_Range.string_of_range e.FStar_Syntax_Syntax.pos in
                   let uu____3628 = FStar_Syntax_Print.term_to_string e in
                   FStar_Util.print2 "%s: Translating match %s\n" uu____3627
                     uu____3628);
              (let scrut2 = unlazy_unmeta scrut1 in
               match scrut2.FStar_TypeChecker_NBETerm.nbe_t with
               | FStar_TypeChecker_NBETerm.Construct (c, us, args) ->
                   (debug1
                      (fun uu____3654 ->
                         let uu____3655 =
                           let uu____3656 =
                             FStar_All.pipe_right args
                               (FStar_List.map
                                  (fun uu____3679 ->
                                     match uu____3679 with
                                     | (x, q) ->
                                         let uu____3692 =
                                           FStar_TypeChecker_NBETerm.t_to_string
                                             x in
                                         Prims.op_Hat
                                           (if FStar_Util.is_some q
                                            then "#"
                                            else "") uu____3692)) in
                           FStar_All.pipe_right uu____3656
                             (FStar_String.concat "; ") in
                         FStar_Util.print1 "Match args: %s\n" uu____3655);
                    (let uu____3696 = pickBranch cfg scrut2 branches in
                     match uu____3696 with
                     | FStar_Pervasives_Native.Some (branch, args1) ->
                         let uu____3717 =
                           FStar_List.fold_left
                             (fun bs1 -> fun x -> x :: bs1) bs args1 in
                         translate cfg uu____3717 branch
                     | FStar_Pervasives_Native.None ->
                         FStar_TypeChecker_NBETerm.mkAccuMatch scrut2
                           make_branches))
               | FStar_TypeChecker_NBETerm.Constant c ->
                   (debug1
                      (fun uu____3740 ->
                         let uu____3741 =
                           FStar_TypeChecker_NBETerm.t_to_string scrut2 in
                         FStar_Util.print1 "Match constant : %s\n" uu____3741);
                    (let uu____3742 = pickBranch cfg scrut2 branches in
                     match uu____3742 with
                     | FStar_Pervasives_Native.Some (branch, []) ->
                         translate cfg bs branch
                     | FStar_Pervasives_Native.Some (branch, arg::[]) ->
                         translate cfg (arg :: bs) branch
                     | FStar_Pervasives_Native.None ->
                         FStar_TypeChecker_NBETerm.mkAccuMatch scrut2
                           make_branches
                     | FStar_Pervasives_Native.Some (uu____3776, hd::tl) ->
                         failwith
                           "Impossible: Matching on constants cannot bind more than one variable"))
               | uu____3789 ->
                   FStar_TypeChecker_NBETerm.mkAccuMatch scrut2 make_branches))
         | FStar_Syntax_Syntax.Tm_meta
             (e1, FStar_Syntax_Syntax.Meta_monadic (m, t)) when
             (cfg.core_cfg).FStar_TypeChecker_Cfg.reifying ->
             translate_monadic (m, t) cfg bs e1
         | FStar_Syntax_Syntax.Tm_meta
             (e1, FStar_Syntax_Syntax.Meta_monadic_lift (m, m', t)) when
             (cfg.core_cfg).FStar_TypeChecker_Cfg.reifying ->
             translate_monadic_lift (m, m', t) cfg bs e1
         | FStar_Syntax_Syntax.Tm_meta (e1, meta) ->
             let norm_meta uu____3828 =
               let norm t =
                 let uu____3835 = translate cfg bs t in
                 readback cfg uu____3835 in
               match meta with
               | FStar_Syntax_Syntax.Meta_named uu____3836 -> meta
               | FStar_Syntax_Syntax.Meta_labeled uu____3837 -> meta
               | FStar_Syntax_Syntax.Meta_desugared uu____3844 -> meta
               | FStar_Syntax_Syntax.Meta_pattern (ts, args) ->
                   let uu____3879 =
                     let uu____3900 = FStar_List.map norm ts in
                     let uu____3909 =
                       FStar_List.map
                         (FStar_List.map
                            (fun uu____3958 ->
                               match uu____3958 with
                               | (t, a) ->
                                   let uu____3977 = norm t in (uu____3977, a)))
                         args in
                     (uu____3900, uu____3909) in
                   FStar_Syntax_Syntax.Meta_pattern uu____3879
               | FStar_Syntax_Syntax.Meta_monadic (m, t) ->
                   let uu____4002 =
                     let uu____4009 = norm t in (m, uu____4009) in
                   FStar_Syntax_Syntax.Meta_monadic uu____4002
               | FStar_Syntax_Syntax.Meta_monadic_lift (m0, m1, t) ->
                   let uu____4021 =
                     let uu____4030 = norm t in (m0, m1, uu____4030) in
                   FStar_Syntax_Syntax.Meta_monadic_lift uu____4021 in
             let uu____4035 =
               let uu____4036 =
                 let uu____4043 = translate cfg bs e1 in
                 let uu____4044 = FStar_Thunk.mk norm_meta in
                 (uu____4043, uu____4044) in
               FStar_TypeChecker_NBETerm.Meta uu____4036 in
             FStar_All.pipe_left mk_t1 uu____4035
         | FStar_Syntax_Syntax.Tm_let ((false, lb::[]), body) ->
             let uu____4063 =
               FStar_TypeChecker_Cfg.should_reduce_local_let cfg.core_cfg lb in
             if uu____4063
             then
               let uu____4064 =
                 (((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.for_extraction
                    &&
                    (FStar_Syntax_Util.is_unit lb.FStar_Syntax_Syntax.lbtyp))
                   &&
                   (FStar_Syntax_Util.is_pure_or_ghost_effect
                      lb.FStar_Syntax_Syntax.lbeff) in
               (if uu____4064
                then
                  let bs1 =
                    let uu____4068 =
                      let uu____4069 =
                        FStar_Syntax_Syntax.range_of_lbname
                          lb.FStar_Syntax_Syntax.lbname in
                      mk_rt uu____4069
                        (FStar_TypeChecker_NBETerm.Constant
                           FStar_TypeChecker_NBETerm.Unit) in
                    uu____4068 :: bs in
                  translate cfg bs1 body
                else
                  (let bs1 =
                     let uu____4074 = translate_letbinding cfg bs lb in
                     uu____4074 :: bs in
                   translate cfg bs1 body))
             else
               (let def uu____4081 =
                  let uu____4082 =
                    (((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.for_extraction
                       &&
                       (FStar_Syntax_Util.is_unit
                          lb.FStar_Syntax_Syntax.lbtyp))
                      &&
                      (FStar_Syntax_Util.is_pure_or_ghost_effect
                         lb.FStar_Syntax_Syntax.lbeff) in
                  if uu____4082
                  then
                    FStar_All.pipe_left mk_t1
                      (FStar_TypeChecker_NBETerm.Constant
                         FStar_TypeChecker_NBETerm.Unit)
                  else translate cfg bs lb.FStar_Syntax_Syntax.lbdef in
                let typ uu____4089 =
                  translate cfg bs lb.FStar_Syntax_Syntax.lbtyp in
                let name =
                  let uu____4091 =
                    FStar_Util.left lb.FStar_Syntax_Syntax.lbname in
                  FStar_Syntax_Syntax.freshen_bv uu____4091 in
                let bs1 =
                  let uu____4095 =
                    let uu____4096 = FStar_Syntax_Syntax.range_of_bv name in
                    mk_rt uu____4096
                      (FStar_TypeChecker_NBETerm.Accu
                         ((FStar_TypeChecker_NBETerm.Var name), [])) in
                  uu____4095 :: bs in
                let body1 uu____4112 = translate cfg bs1 body in
                let uu____4113 =
                  let uu____4114 =
                    let uu____4125 =
                      let uu____4126 =
                        let uu____4143 = FStar_Thunk.mk typ in
                        let uu____4146 = FStar_Thunk.mk def in
                        let uu____4149 = FStar_Thunk.mk body1 in
                        (name, uu____4143, uu____4146, uu____4149, lb) in
                      FStar_TypeChecker_NBETerm.UnreducedLet uu____4126 in
                    (uu____4125, []) in
                  FStar_TypeChecker_NBETerm.Accu uu____4114 in
                FStar_All.pipe_left mk_t1 uu____4113)
         | FStar_Syntax_Syntax.Tm_let ((_rec, lbs), body) ->
             if
               (Prims.op_Negation
                  ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.zeta)
                 &&
                 ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.pure_subterms_within_computations
             then
               let vars =
                 FStar_List.map
                   (fun lb ->
                      let uu____4191 =
                        FStar_Util.left lb.FStar_Syntax_Syntax.lbname in
                      FStar_Syntax_Syntax.freshen_bv uu____4191) lbs in
               let typs =
                 FStar_List.map
                   (fun lb -> translate cfg bs lb.FStar_Syntax_Syntax.lbtyp)
                   lbs in
               let rec_bs =
                 let uu____4200 =
                   FStar_List.map
                     (fun v ->
                        let uu____4206 =
                          let uu____4211 = FStar_Syntax_Syntax.range_of_bv v in
                          mk_rt uu____4211 in
                        FStar_All.pipe_left uu____4206
                          (FStar_TypeChecker_NBETerm.Accu
                             ((FStar_TypeChecker_NBETerm.Var v), []))) vars in
                 FStar_List.append uu____4200 bs in
               let defs =
                 FStar_List.map
                   (fun lb ->
                      translate cfg rec_bs lb.FStar_Syntax_Syntax.lbdef) lbs in
               let body1 = translate cfg rec_bs body in
               let uu____4228 =
                 let uu____4229 =
                   let uu____4240 =
                     let uu____4241 =
                       let uu____4258 = FStar_List.zip3 vars typs defs in
                       (uu____4258, body1, lbs) in
                     FStar_TypeChecker_NBETerm.UnreducedLetRec uu____4241 in
                   (uu____4240, []) in
                 FStar_TypeChecker_NBETerm.Accu uu____4229 in
               FStar_All.pipe_left mk_t1 uu____4228
             else
               (let uu____4288 = make_rec_env lbs bs in
                translate cfg uu____4288 body)
         | FStar_Syntax_Syntax.Tm_quoted (qt, qi) ->
             let close t =
               let bvs =
                 FStar_List.map
                   (fun uu____4307 ->
                      FStar_Syntax_Syntax.new_bv FStar_Pervasives_Native.None
                        FStar_Syntax_Syntax.tun) bs in
               let s1 =
                 FStar_List.mapi
                   (fun i -> fun bv -> FStar_Syntax_Syntax.DB (i, bv)) bvs in
               let s2 =
                 let uu____4318 = FStar_List.zip bvs bs in
                 FStar_List.map
                   (fun uu____4333 ->
                      match uu____4333 with
                      | (bv, t1) ->
                          let uu____4340 =
                            let uu____4347 = readback cfg t1 in
                            (bv, uu____4347) in
                          FStar_Syntax_Syntax.NT uu____4340) uu____4318 in
               let uu____4352 = FStar_Syntax_Subst.subst s1 t in
               FStar_Syntax_Subst.subst s2 uu____4352 in
             (match qi.FStar_Syntax_Syntax.qkind with
              | FStar_Syntax_Syntax.Quote_dynamic ->
                  let qt1 = close qt in
                  FStar_All.pipe_left mk_t1
                    (FStar_TypeChecker_NBETerm.Quote (qt1, qi))
              | FStar_Syntax_Syntax.Quote_static ->
                  let qi1 = FStar_Syntax_Syntax.on_antiquoted close qi in
                  FStar_All.pipe_left mk_t1
                    (FStar_TypeChecker_NBETerm.Quote (qt, qi1)))
         | FStar_Syntax_Syntax.Tm_lazy li ->
             let f uu____4361 =
               let t = FStar_Syntax_Util.unfold_lazy li in
               debug1
                 (fun uu____4368 ->
                    let uu____4369 = FStar_Syntax_Print.term_to_string t in
                    FStar_Util.print1 ">> Unfolding Tm_lazy to %s\n"
                      uu____4369);
               translate cfg bs t in
             let uu____4370 =
               let uu____4371 =
                 let uu____4386 = FStar_Thunk.mk f in
                 ((FStar_Util.Inl li), uu____4386) in
               FStar_TypeChecker_NBETerm.Lazy uu____4371 in
             FStar_All.pipe_left mk_t1 uu____4370)
and (translate_comp :
  config ->
    FStar_TypeChecker_NBETerm.t Prims.list ->
      FStar_Syntax_Syntax.comp -> FStar_TypeChecker_NBETerm.comp)
  =
  fun cfg ->
    fun bs ->
      fun c ->
        match c.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Total (typ, u) ->
            let uu____4418 =
              let uu____4425 = translate cfg bs typ in
              let uu____4426 = fmap_opt (translate_univ cfg bs) u in
              (uu____4425, uu____4426) in
            FStar_TypeChecker_NBETerm.Tot uu____4418
        | FStar_Syntax_Syntax.GTotal (typ, u) ->
            let uu____4441 =
              let uu____4448 = translate cfg bs typ in
              let uu____4449 = fmap_opt (translate_univ cfg bs) u in
              (uu____4448, uu____4449) in
            FStar_TypeChecker_NBETerm.GTot uu____4441
        | FStar_Syntax_Syntax.Comp ctyp ->
            let uu____4455 = translate_comp_typ cfg bs ctyp in
            FStar_TypeChecker_NBETerm.Comp uu____4455
and (iapp :
  config ->
    FStar_TypeChecker_NBETerm.t ->
      FStar_TypeChecker_NBETerm.args -> FStar_TypeChecker_NBETerm.t)
  =
  fun cfg ->
    fun f ->
      fun args ->
        let mk t = mk_rt f.FStar_TypeChecker_NBETerm.nbe_r t in
        let uu____4465 =
          let uu____4466 = unlazy_unmeta f in
          uu____4466.FStar_TypeChecker_NBETerm.nbe_t in
        match uu____4465 with
        | FStar_TypeChecker_NBETerm.Lam (f1, binders, n) ->
            let m = FStar_List.length args in
            if m < n
            then
              let arg_values_rev = map_rev FStar_Pervasives_Native.fst args in
              let binders1 =
                match binders with
                | FStar_Util.Inr raw_args ->
                    let uu____4596 = FStar_List.splitAt m raw_args in
                    (match uu____4596 with
                     | (uu____4637, raw_args1) -> FStar_Util.Inr raw_args1)
                | FStar_Util.Inl (ctx, xs, rc) ->
                    let uu____4706 = FStar_List.splitAt m xs in
                    (match uu____4706 with
                     | (uu____4753, xs1) ->
                         let ctx1 = FStar_List.append arg_values_rev ctx in
                         FStar_Util.Inl (ctx1, xs1, rc)) in
              FStar_All.pipe_left mk
                (FStar_TypeChecker_NBETerm.Lam
                   ((fun l -> f1 (FStar_List.append l arg_values_rev)),
                     binders1, (n - m)))
            else
              if m = n
              then
                (let arg_values_rev =
                   map_rev FStar_Pervasives_Native.fst args in
                 f1 arg_values_rev)
              else
                (let uu____4848 = FStar_List.splitAt n args in
                 match uu____4848 with
                 | (args1, args') ->
                     let uu____4895 =
                       let uu____4896 =
                         map_rev FStar_Pervasives_Native.fst args1 in
                       f1 uu____4896 in
                     iapp cfg uu____4895 args')
        | FStar_TypeChecker_NBETerm.Accu (a, ts) ->
            FStar_All.pipe_left mk
              (FStar_TypeChecker_NBETerm.Accu
                 (a, (FStar_List.rev_append args ts)))
        | FStar_TypeChecker_NBETerm.Construct (i, us, ts) ->
            let rec aux args1 us1 ts1 =
              match args1 with
              | ({
                   FStar_TypeChecker_NBETerm.nbe_t =
                     FStar_TypeChecker_NBETerm.Univ u;
                   FStar_TypeChecker_NBETerm.nbe_r = uu____5015;_},
                 uu____5016)::args2 -> aux args2 (u :: us1) ts1
              | a::args2 -> aux args2 us1 (a :: ts1)
              | [] -> (us1, ts1) in
            let uu____5060 = aux args us ts in
            (match uu____5060 with
             | (us', ts') ->
                 FStar_All.pipe_left mk
                   (FStar_TypeChecker_NBETerm.Construct (i, us', ts')))
        | FStar_TypeChecker_NBETerm.FV (i, us, ts) ->
            let rec aux args1 us1 ts1 =
              match args1 with
              | ({
                   FStar_TypeChecker_NBETerm.nbe_t =
                     FStar_TypeChecker_NBETerm.Univ u;
                   FStar_TypeChecker_NBETerm.nbe_r = uu____5187;_},
                 uu____5188)::args2 -> aux args2 (u :: us1) ts1
              | a::args2 -> aux args2 us1 (a :: ts1)
              | [] -> (us1, ts1) in
            let uu____5232 = aux args us ts in
            (match uu____5232 with
             | (us', ts') ->
                 FStar_All.pipe_left mk
                   (FStar_TypeChecker_NBETerm.FV (i, us', ts')))
        | FStar_TypeChecker_NBETerm.TopLevelLet (lb, arity, args_rev) ->
            let args_rev1 = FStar_List.rev_append args args_rev in
            let n_args_rev = FStar_List.length args_rev1 in
            let n_univs = FStar_List.length lb.FStar_Syntax_Syntax.lbunivs in
            (debug cfg
               (fun uu____5308 ->
                  let uu____5309 =
                    FStar_Syntax_Print.lbname_to_string
                      lb.FStar_Syntax_Syntax.lbname in
                  let uu____5310 = FStar_Util.string_of_int arity in
                  let uu____5311 = FStar_Util.string_of_int n_args_rev in
                  FStar_Util.print3
                    "Reached iapp for %s with arity %s and n_args = %s\n"
                    uu____5309 uu____5310 uu____5311);
             if n_args_rev >= arity
             then
               (let uu____5312 =
                  let uu____5325 =
                    let uu____5326 =
                      FStar_Syntax_Util.unascribe
                        lb.FStar_Syntax_Syntax.lbdef in
                    uu____5326.FStar_Syntax_Syntax.n in
                  match uu____5325 with
                  | FStar_Syntax_Syntax.Tm_abs (bs, body, uu____5343) ->
                      (bs, body)
                  | uu____5376 -> ([], (lb.FStar_Syntax_Syntax.lbdef)) in
                match uu____5312 with
                | (bs, body) ->
                    if (n_univs + (FStar_List.length bs)) = arity
                    then
                      let uu____5415 =
                        FStar_Util.first_N (n_args_rev - arity) args_rev1 in
                      (match uu____5415 with
                       | (extra, args_rev2) ->
                           (debug cfg
                              (fun uu____5467 ->
                                 let uu____5468 =
                                   FStar_Syntax_Print.lbname_to_string
                                     lb.FStar_Syntax_Syntax.lbname in
                                 let uu____5469 =
                                   FStar_Syntax_Print.term_to_string body in
                                 let uu____5470 =
                                   let uu____5471 =
                                     FStar_List.map
                                       (fun uu____5481 ->
                                          match uu____5481 with
                                          | (x, uu____5487) ->
                                              FStar_TypeChecker_NBETerm.t_to_string
                                                x) args_rev2 in
                                   FStar_All.pipe_right uu____5471
                                     (FStar_String.concat ", ") in
                                 FStar_Util.print3
                                   "Reducing body of %s = %s,\n\twith args = %s\n"
                                   uu____5468 uu____5469 uu____5470);
                            (let t =
                               let uu____5491 =
                                 FStar_List.map FStar_Pervasives_Native.fst
                                   args_rev2 in
                               translate cfg uu____5491 body in
                             match extra with
                             | [] -> t
                             | uu____5502 ->
                                 iapp cfg t (FStar_List.rev extra))))
                    else
                      (let uu____5514 =
                         FStar_Util.first_N (n_args_rev - n_univs) args_rev1 in
                       match uu____5514 with
                       | (extra, univs) ->
                           let uu____5561 =
                             let uu____5562 =
                               FStar_List.map FStar_Pervasives_Native.fst
                                 univs in
                             translate cfg uu____5562
                               lb.FStar_Syntax_Syntax.lbdef in
                           iapp cfg uu____5561 (FStar_List.rev extra)))
             else
               FStar_All.pipe_left mk
                 (FStar_TypeChecker_NBETerm.TopLevelLet
                    (lb, arity, args_rev1)))
        | FStar_TypeChecker_NBETerm.TopLevelRec
            (lb, arity, decreases_list, args') ->
            let args1 = FStar_List.append args' args in
            if (FStar_List.length args1) >= arity
            then
              let uu____5615 =
                should_reduce_recursive_definition args1 decreases_list in
              (match uu____5615 with
               | (should_reduce, uu____5623, uu____5624) ->
                   if Prims.op_Negation should_reduce
                   then
                     let fv = FStar_Util.right lb.FStar_Syntax_Syntax.lbname in
                     (debug cfg
                        (fun uu____5629 ->
                           let uu____5630 =
                             FStar_Syntax_Print.fv_to_string fv in
                           FStar_Util.print1
                             "Decided to not unfold recursive definition %s\n"
                             uu____5630);
                      (let uu____5631 =
                         let uu____5632 = FStar_Syntax_Syntax.range_of_fv fv in
                         mk_rt uu____5632
                           (FStar_TypeChecker_NBETerm.FV (fv, [], [])) in
                       iapp cfg uu____5631 args1))
                   else
                     (debug cfg
                        (fun uu____5649 ->
                           let uu____5650 =
                             let uu____5651 =
                               FStar_Util.right lb.FStar_Syntax_Syntax.lbname in
                             FStar_Syntax_Print.fv_to_string uu____5651 in
                           FStar_Util.print1
                             "Yes, Decided to unfold recursive definition %s\n"
                             uu____5650);
                      (let uu____5652 =
                         FStar_Util.first_N
                           (FStar_List.length lb.FStar_Syntax_Syntax.lbunivs)
                           args1 in
                       match uu____5652 with
                       | (univs, rest) ->
                           let uu____5699 =
                             let uu____5700 =
                               let uu____5703 =
                                 FStar_List.map FStar_Pervasives_Native.fst
                                   univs in
                               FStar_List.rev uu____5703 in
                             translate cfg uu____5700
                               lb.FStar_Syntax_Syntax.lbdef in
                           iapp cfg uu____5699 rest)))
            else
              FStar_All.pipe_left mk
                (FStar_TypeChecker_NBETerm.TopLevelRec
                   (lb, arity, decreases_list, args1))
        | FStar_TypeChecker_NBETerm.LocalLetRec
            (i, lb, mutual_lbs, local_env, acc_args, remaining_arity,
             decreases_list)
            ->
            if remaining_arity = Prims.int_zero
            then
              FStar_All.pipe_left mk
                (FStar_TypeChecker_NBETerm.LocalLetRec
                   (i, lb, mutual_lbs, local_env,
                     (FStar_List.append acc_args args), remaining_arity,
                     decreases_list))
            else
              (let n_args = FStar_List.length args in
               if n_args < remaining_arity
               then
                 FStar_All.pipe_left mk
                   (FStar_TypeChecker_NBETerm.LocalLetRec
                      (i, lb, mutual_lbs, local_env,
                        (FStar_List.append acc_args args),
                        (remaining_arity - n_args), decreases_list))
               else
                 (let args1 = FStar_List.append acc_args args in
                  let uu____5800 =
                    should_reduce_recursive_definition args1 decreases_list in
                  match uu____5800 with
                  | (should_reduce, uu____5808, uu____5809) ->
                      if Prims.op_Negation should_reduce
                      then
                        FStar_All.pipe_left mk
                          (FStar_TypeChecker_NBETerm.LocalLetRec
                             (i, lb, mutual_lbs, local_env, args1,
                               Prims.int_zero, decreases_list))
                      else
                        (let env = make_rec_env mutual_lbs local_env in
                         debug cfg
                           (fun uu____5830 ->
                              (let uu____5832 =
                                 let uu____5833 =
                                   FStar_List.map
                                     FStar_TypeChecker_NBETerm.t_to_string
                                     env in
                                 FStar_String.concat ",\n\t " uu____5833 in
                               FStar_Util.print1
                                 "LocalLetRec Env = {\n\t%s\n}\n" uu____5832);
                              (let uu____5836 =
                                 let uu____5837 =
                                   FStar_List.map
                                     (fun uu____5847 ->
                                        match uu____5847 with
                                        | (t, uu____5853) ->
                                            FStar_TypeChecker_NBETerm.t_to_string
                                              t) args1 in
                                 FStar_String.concat ",\n\t " uu____5837 in
                               FStar_Util.print1
                                 "LocalLetRec Args = {\n\t%s\n}\n" uu____5836));
                         (let uu____5854 =
                            translate cfg env lb.FStar_Syntax_Syntax.lbdef in
                          iapp cfg uu____5854 args1))))
        | FStar_TypeChecker_NBETerm.Constant
            (FStar_TypeChecker_NBETerm.SConst (FStar_Const.Const_range_of))
            ->
            (match args with
             | (a, uu____5856)::[] ->
                 mk_rt a.FStar_TypeChecker_NBETerm.nbe_r
                   (FStar_TypeChecker_NBETerm.Constant
                      (FStar_TypeChecker_NBETerm.Range
                         (a.FStar_TypeChecker_NBETerm.nbe_r)))
             | uu____5865 ->
                 let uu____5866 =
                   let uu____5867 = FStar_TypeChecker_NBETerm.t_to_string f in
                   Prims.op_Hat "NBE ill-typed application: " uu____5867 in
                 failwith uu____5866)
        | FStar_TypeChecker_NBETerm.Constant
            (FStar_TypeChecker_NBETerm.SConst
            (FStar_Const.Const_set_range_of)) ->
            (match args with
             | (t, uu____5869)::({
                                   FStar_TypeChecker_NBETerm.nbe_t =
                                     FStar_TypeChecker_NBETerm.Constant
                                     (FStar_TypeChecker_NBETerm.Range r);
                                   FStar_TypeChecker_NBETerm.nbe_r =
                                     uu____5871;_},
                                 uu____5872)::[]
                 ->
                 let uu___934_5885 = t in
                 {
                   FStar_TypeChecker_NBETerm.nbe_t =
                     (uu___934_5885.FStar_TypeChecker_NBETerm.nbe_t);
                   FStar_TypeChecker_NBETerm.nbe_r = r
                 }
             | uu____5886 ->
                 let uu____5887 =
                   let uu____5888 = FStar_TypeChecker_NBETerm.t_to_string f in
                   Prims.op_Hat "NBE ill-typed application: " uu____5888 in
                 failwith uu____5887)
        | uu____5889 ->
            let uu____5890 =
              let uu____5891 = FStar_TypeChecker_NBETerm.t_to_string f in
              Prims.op_Hat "NBE ill-typed application: " uu____5891 in
            failwith uu____5890
and (translate_fv :
  config ->
    FStar_TypeChecker_NBETerm.t Prims.list ->
      FStar_Syntax_Syntax.fv -> FStar_TypeChecker_NBETerm.t)
  =
  fun cfg ->
    fun bs ->
      fun fvar ->
        let debug1 = debug cfg in
        let qninfo =
          let uu____5906 = FStar_TypeChecker_Cfg.cfg_env cfg.core_cfg in
          let uu____5907 = FStar_Syntax_Syntax.lid_of_fv fvar in
          FStar_TypeChecker_Env.lookup_qname uu____5906 uu____5907 in
        let uu____5908 = (is_constr qninfo) || (is_constr_fv fvar) in
        if uu____5908
        then FStar_TypeChecker_NBETerm.mkConstruct fvar [] []
        else
          (let uu____5914 =
             FStar_TypeChecker_Normalize.should_unfold cfg.core_cfg
               (fun uu____5916 ->
                  (cfg.core_cfg).FStar_TypeChecker_Cfg.reifying) fvar qninfo in
           match uu____5914 with
           | FStar_TypeChecker_Normalize.Should_unfold_fully ->
               failwith "Not yet handled"
           | FStar_TypeChecker_Normalize.Should_unfold_no ->
               (debug1
                  (fun uu____5922 ->
                     let uu____5923 = FStar_Syntax_Print.fv_to_string fvar in
                     FStar_Util.print1 "(1) Decided to not unfold %s\n"
                       uu____5923);
                (let uu____5924 =
                   FStar_TypeChecker_Cfg.find_prim_step cfg.core_cfg fvar in
                 match uu____5924 with
                 | FStar_Pervasives_Native.Some prim_step when
                     prim_step.FStar_TypeChecker_Cfg.strong_reduction_ok ->
                     let arity =
                       prim_step.FStar_TypeChecker_Cfg.arity +
                         prim_step.FStar_TypeChecker_Cfg.univ_arity in
                     (debug1
                        (fun uu____5934 ->
                           let uu____5935 =
                             FStar_Syntax_Print.fv_to_string fvar in
                           FStar_Util.print1 "Found a primop %s\n" uu____5935);
                      (let uu____5936 =
                         let uu____5937 =
                           let uu____5969 =
                             let f uu____6001 =
                               let uu____6002 =
                                 FStar_Syntax_Syntax.new_bv
                                   FStar_Pervasives_Native.None
                                   FStar_Syntax_Syntax.t_unit in
                               (uu____6002, FStar_Pervasives_Native.None) in
                             let uu____6005 =
                               let uu____6016 = FStar_Common.tabulate arity f in
                               ([], uu____6016, FStar_Pervasives_Native.None) in
                             FStar_Util.Inl uu____6005 in
                           ((fun args_rev ->
                               let args' =
                                 map_rev FStar_TypeChecker_NBETerm.as_arg
                                   args_rev in
                               let callbacks =
                                 {
                                   FStar_TypeChecker_NBETerm.iapp =
                                     (iapp cfg);
                                   FStar_TypeChecker_NBETerm.translate =
                                     (translate cfg bs)
                                 } in
                               let uu____6089 =
                                 prim_step.FStar_TypeChecker_Cfg.interpretation_nbe
                                   callbacks args' in
                               match uu____6089 with
                               | FStar_Pervasives_Native.Some x ->
                                   (debug1
                                      (fun uu____6100 ->
                                         let uu____6101 =
                                           FStar_Syntax_Print.fv_to_string
                                             fvar in
                                         let uu____6102 =
                                           FStar_TypeChecker_NBETerm.t_to_string
                                             x in
                                         FStar_Util.print2
                                           "Primitive operator %s returned %s\n"
                                           uu____6101 uu____6102);
                                    x)
                               | FStar_Pervasives_Native.None ->
                                   (debug1
                                      (fun uu____6108 ->
                                         let uu____6109 =
                                           FStar_Syntax_Print.fv_to_string
                                             fvar in
                                         FStar_Util.print1
                                           "Primitive operator %s failed\n"
                                           uu____6109);
                                    (let uu____6110 =
                                       FStar_TypeChecker_NBETerm.mkFV fvar []
                                         [] in
                                     iapp cfg uu____6110 args'))),
                             uu____5969, arity) in
                         FStar_TypeChecker_NBETerm.Lam uu____5937 in
                       FStar_All.pipe_left mk_t uu____5936))
                 | FStar_Pervasives_Native.Some uu____6115 ->
                     (debug1
                        (fun uu____6121 ->
                           let uu____6122 =
                             FStar_Syntax_Print.fv_to_string fvar in
                           FStar_Util.print1 "(2) Decided to not unfold %s\n"
                             uu____6122);
                      FStar_TypeChecker_NBETerm.mkFV fvar [] [])
                 | uu____6127 ->
                     (debug1
                        (fun uu____6135 ->
                           let uu____6136 =
                             FStar_Syntax_Print.fv_to_string fvar in
                           FStar_Util.print1 "(3) Decided to not unfold %s\n"
                             uu____6136);
                      FStar_TypeChecker_NBETerm.mkFV fvar [] [])))
           | FStar_TypeChecker_Normalize.Should_unfold_reify ->
               let t =
                 let is_qninfo_visible =
                   let uu____6143 =
                     FStar_TypeChecker_Env.lookup_definition_qninfo
                       (cfg.core_cfg).FStar_TypeChecker_Cfg.delta_level
                       (fvar.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                       qninfo in
                   FStar_Option.isSome uu____6143 in
                 if is_qninfo_visible
                 then
                   match qninfo with
                   | FStar_Pervasives_Native.Some
                       (FStar_Util.Inr
                        ({
                           FStar_Syntax_Syntax.sigel =
                             FStar_Syntax_Syntax.Sig_let
                             ((is_rec, lbs), names);
                           FStar_Syntax_Syntax.sigrng = uu____6157;
                           FStar_Syntax_Syntax.sigquals = uu____6158;
                           FStar_Syntax_Syntax.sigmeta = uu____6159;
                           FStar_Syntax_Syntax.sigattrs = uu____6160;
                           FStar_Syntax_Syntax.sigopts = uu____6161;_},
                         _us_opt),
                        _rng)
                       ->
                       (debug1
                          (fun uu____6229 ->
                             let uu____6230 =
                               FStar_Syntax_Print.fv_to_string fvar in
                             FStar_Util.print1 "(1) Decided to unfold %s\n"
                               uu____6230);
                        (let lbm = find_let lbs fvar in
                         match lbm with
                         | FStar_Pervasives_Native.Some lb ->
                             if
                               is_rec &&
                                 ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.zeta
                             then
                               let uu____6235 = let_rec_arity lb in
                               (match uu____6235 with
                                | (ar, lst) ->
                                    let uu____6248 =
                                      let uu____6253 =
                                        FStar_Syntax_Syntax.range_of_fv fvar in
                                      mk_rt uu____6253 in
                                    FStar_All.pipe_left uu____6248
                                      (FStar_TypeChecker_NBETerm.TopLevelRec
                                         (lb, ar, lst, [])))
                             else translate_letbinding cfg bs lb
                         | FStar_Pervasives_Native.None ->
                             failwith "Could not find let binding"))
                   | uu____6267 ->
                       (debug1
                          (fun uu____6273 ->
                             let uu____6274 =
                               FStar_Syntax_Print.fv_to_string fvar in
                             FStar_Util.print1
                               "(1) qninfo is None for (%s)\n" uu____6274);
                        FStar_TypeChecker_NBETerm.mkFV fvar [] [])
                 else
                   (debug1
                      (fun uu____6285 ->
                         let uu____6286 =
                           FStar_Syntax_Print.fv_to_string fvar in
                         FStar_Util.print1
                           "(1) qninfo is not visible at this level (%s)\n"
                           uu____6286);
                    FStar_TypeChecker_NBETerm.mkFV fvar [] []) in
               (cache_add cfg fvar t; t)
           | FStar_TypeChecker_Normalize.Should_unfold_yes ->
               let t =
                 let is_qninfo_visible =
                   let uu____6294 =
                     FStar_TypeChecker_Env.lookup_definition_qninfo
                       (cfg.core_cfg).FStar_TypeChecker_Cfg.delta_level
                       (fvar.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                       qninfo in
                   FStar_Option.isSome uu____6294 in
                 if is_qninfo_visible
                 then
                   match qninfo with
                   | FStar_Pervasives_Native.Some
                       (FStar_Util.Inr
                        ({
                           FStar_Syntax_Syntax.sigel =
                             FStar_Syntax_Syntax.Sig_let
                             ((is_rec, lbs), names);
                           FStar_Syntax_Syntax.sigrng = uu____6308;
                           FStar_Syntax_Syntax.sigquals = uu____6309;
                           FStar_Syntax_Syntax.sigmeta = uu____6310;
                           FStar_Syntax_Syntax.sigattrs = uu____6311;
                           FStar_Syntax_Syntax.sigopts = uu____6312;_},
                         _us_opt),
                        _rng)
                       ->
                       (debug1
                          (fun uu____6380 ->
                             let uu____6381 =
                               FStar_Syntax_Print.fv_to_string fvar in
                             FStar_Util.print1 "(1) Decided to unfold %s\n"
                               uu____6381);
                        (let lbm = find_let lbs fvar in
                         match lbm with
                         | FStar_Pervasives_Native.Some lb ->
                             if
                               is_rec &&
                                 ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.zeta
                             then
                               let uu____6386 = let_rec_arity lb in
                               (match uu____6386 with
                                | (ar, lst) ->
                                    let uu____6399 =
                                      let uu____6404 =
                                        FStar_Syntax_Syntax.range_of_fv fvar in
                                      mk_rt uu____6404 in
                                    FStar_All.pipe_left uu____6399
                                      (FStar_TypeChecker_NBETerm.TopLevelRec
                                         (lb, ar, lst, [])))
                             else translate_letbinding cfg bs lb
                         | FStar_Pervasives_Native.None ->
                             failwith "Could not find let binding"))
                   | uu____6418 ->
                       (debug1
                          (fun uu____6424 ->
                             let uu____6425 =
                               FStar_Syntax_Print.fv_to_string fvar in
                             FStar_Util.print1
                               "(1) qninfo is None for (%s)\n" uu____6425);
                        FStar_TypeChecker_NBETerm.mkFV fvar [] [])
                 else
                   (debug1
                      (fun uu____6436 ->
                         let uu____6437 =
                           FStar_Syntax_Print.fv_to_string fvar in
                         FStar_Util.print1
                           "(1) qninfo is not visible at this level (%s)\n"
                           uu____6437);
                    FStar_TypeChecker_NBETerm.mkFV fvar [] []) in
               (cache_add cfg fvar t; t))
and (translate_letbinding :
  config ->
    FStar_TypeChecker_NBETerm.t Prims.list ->
      FStar_Syntax_Syntax.letbinding -> FStar_TypeChecker_NBETerm.t)
  =
  fun cfg ->
    fun bs ->
      fun lb ->
        let debug1 = debug cfg in
        let us = lb.FStar_Syntax_Syntax.lbunivs in
        let uu____6459 =
          FStar_Syntax_Util.arrow_formals lb.FStar_Syntax_Syntax.lbtyp in
        match uu____6459 with
        | (formals, uu____6467) ->
            let arity = (FStar_List.length us) + (FStar_List.length formals) in
            if arity = Prims.int_zero
            then translate cfg bs lb.FStar_Syntax_Syntax.lbdef
            else
              (let uu____6480 =
                 FStar_Util.is_right lb.FStar_Syntax_Syntax.lbname in
               if uu____6480
               then
                 (debug1
                    (fun uu____6488 ->
                       let uu____6489 =
                         FStar_Syntax_Print.lbname_to_string
                           lb.FStar_Syntax_Syntax.lbname in
                       let uu____6490 = FStar_Util.string_of_int arity in
                       FStar_Util.print2
                         "Making TopLevelLet for %s with arity %s\n"
                         uu____6489 uu____6490);
                  (let uu____6491 =
                     let uu____6496 =
                       FStar_Syntax_Syntax.range_of_lbname
                         lb.FStar_Syntax_Syntax.lbname in
                     mk_rt uu____6496 in
                   FStar_All.pipe_left uu____6491
                     (FStar_TypeChecker_NBETerm.TopLevelLet (lb, arity, []))))
               else translate cfg bs lb.FStar_Syntax_Syntax.lbdef)
and (mkRec :
  Prims.int ->
    FStar_Syntax_Syntax.letbinding ->
      FStar_Syntax_Syntax.letbinding Prims.list ->
        FStar_TypeChecker_NBETerm.t Prims.list -> FStar_TypeChecker_NBETerm.t)
  =
  fun i ->
    fun b ->
      fun bs ->
        fun env ->
          let uu____6516 = let_rec_arity b in
          match uu____6516 with
          | (ar, ar_lst) ->
              FStar_All.pipe_left mk_t
                (FStar_TypeChecker_NBETerm.LocalLetRec
                   (i, b, bs, env, [], ar, ar_lst))
and (make_rec_env :
  FStar_Syntax_Syntax.letbinding Prims.list ->
    FStar_TypeChecker_NBETerm.t Prims.list ->
      FStar_TypeChecker_NBETerm.t Prims.list)
  =
  fun all_lbs ->
    fun all_outer_bs ->
      let rec_bindings =
        FStar_List.mapi (fun i -> fun lb -> mkRec i lb all_lbs all_outer_bs)
          all_lbs in
      FStar_List.rev_append rec_bindings all_outer_bs
and (translate_constant :
  FStar_Syntax_Syntax.sconst -> FStar_TypeChecker_NBETerm.constant) =
  fun c ->
    match c with
    | FStar_Const.Const_unit -> FStar_TypeChecker_NBETerm.Unit
    | FStar_Const.Const_bool b -> FStar_TypeChecker_NBETerm.Bool b
    | FStar_Const.Const_int (s, FStar_Pervasives_Native.None) ->
        let uu____6573 = FStar_BigInt.big_int_of_string s in
        FStar_TypeChecker_NBETerm.Int uu____6573
    | FStar_Const.Const_string (s, r) ->
        FStar_TypeChecker_NBETerm.String (s, r)
    | FStar_Const.Const_char c1 -> FStar_TypeChecker_NBETerm.Char c1
    | FStar_Const.Const_range r -> FStar_TypeChecker_NBETerm.Range r
    | uu____6578 -> FStar_TypeChecker_NBETerm.SConst c
and (readback_comp :
  config -> FStar_TypeChecker_NBETerm.comp -> FStar_Syntax_Syntax.comp) =
  fun cfg ->
    fun c ->
      let c' =
        match c with
        | FStar_TypeChecker_NBETerm.Tot (typ, u) ->
            let uu____6588 =
              let uu____6597 = readback cfg typ in (uu____6597, u) in
            FStar_Syntax_Syntax.Total uu____6588
        | FStar_TypeChecker_NBETerm.GTot (typ, u) ->
            let uu____6610 =
              let uu____6619 = readback cfg typ in (uu____6619, u) in
            FStar_Syntax_Syntax.GTotal uu____6610
        | FStar_TypeChecker_NBETerm.Comp ctyp ->
            let uu____6627 = readback_comp_typ cfg ctyp in
            FStar_Syntax_Syntax.Comp uu____6627 in
      FStar_Syntax_Syntax.mk c' FStar_Range.dummyRange
and (translate_comp_typ :
  config ->
    FStar_TypeChecker_NBETerm.t Prims.list ->
      FStar_Syntax_Syntax.comp_typ -> FStar_TypeChecker_NBETerm.comp_typ)
  =
  fun cfg ->
    fun bs ->
      fun c ->
        let uu____6633 = c in
        match uu____6633 with
        | { FStar_Syntax_Syntax.comp_univs = comp_univs;
            FStar_Syntax_Syntax.effect_name = effect_name;
            FStar_Syntax_Syntax.result_typ = result_typ;
            FStar_Syntax_Syntax.effect_args = effect_args;
            FStar_Syntax_Syntax.flags = flags;_} ->
            let uu____6653 =
              FStar_List.map (translate_univ cfg bs) comp_univs in
            let uu____6654 = translate cfg bs result_typ in
            let uu____6655 =
              FStar_List.map
                (fun x ->
                   let uu____6683 =
                     translate cfg bs (FStar_Pervasives_Native.fst x) in
                   (uu____6683, (FStar_Pervasives_Native.snd x))) effect_args in
            let uu____6690 = FStar_List.map (translate_flag cfg bs) flags in
            {
              FStar_TypeChecker_NBETerm.comp_univs = uu____6653;
              FStar_TypeChecker_NBETerm.effect_name = effect_name;
              FStar_TypeChecker_NBETerm.result_typ = uu____6654;
              FStar_TypeChecker_NBETerm.effect_args = uu____6655;
              FStar_TypeChecker_NBETerm.flags = uu____6690
            }
and (readback_comp_typ :
  config ->
    FStar_TypeChecker_NBETerm.comp_typ -> FStar_Syntax_Syntax.comp_typ)
  =
  fun cfg ->
    fun c ->
      let uu____6695 = readback cfg c.FStar_TypeChecker_NBETerm.result_typ in
      let uu____6698 =
        FStar_List.map
          (fun x ->
             let uu____6724 = readback cfg (FStar_Pervasives_Native.fst x) in
             (uu____6724, (FStar_Pervasives_Native.snd x)))
          c.FStar_TypeChecker_NBETerm.effect_args in
      let uu____6725 =
        FStar_List.map (readback_flag cfg) c.FStar_TypeChecker_NBETerm.flags in
      {
        FStar_Syntax_Syntax.comp_univs =
          (c.FStar_TypeChecker_NBETerm.comp_univs);
        FStar_Syntax_Syntax.effect_name =
          (c.FStar_TypeChecker_NBETerm.effect_name);
        FStar_Syntax_Syntax.result_typ = uu____6695;
        FStar_Syntax_Syntax.effect_args = uu____6698;
        FStar_Syntax_Syntax.flags = uu____6725
      }
and (translate_residual_comp :
  config ->
    FStar_TypeChecker_NBETerm.t Prims.list ->
      FStar_Syntax_Syntax.residual_comp ->
        FStar_TypeChecker_NBETerm.residual_comp)
  =
  fun cfg ->
    fun bs ->
      fun c ->
        let uu____6733 = c in
        match uu____6733 with
        | { FStar_Syntax_Syntax.residual_effect = residual_effect;
            FStar_Syntax_Syntax.residual_typ = residual_typ;
            FStar_Syntax_Syntax.residual_flags = residual_flags;_} ->
            let uu____6743 =
              if
                ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.for_extraction
              then FStar_Pervasives_Native.None
              else FStar_Util.map_opt residual_typ (translate cfg bs) in
            let uu____6751 =
              FStar_List.map (translate_flag cfg bs) residual_flags in
            {
              FStar_TypeChecker_NBETerm.residual_effect = residual_effect;
              FStar_TypeChecker_NBETerm.residual_typ = uu____6743;
              FStar_TypeChecker_NBETerm.residual_flags = uu____6751
            }
and (readback_residual_comp :
  config ->
    FStar_TypeChecker_NBETerm.residual_comp ->
      FStar_Syntax_Syntax.residual_comp)
  =
  fun cfg ->
    fun c ->
      let uu____6756 =
        FStar_Util.map_opt c.FStar_TypeChecker_NBETerm.residual_typ
          (fun x ->
             debug cfg
               (fun uu____6767 ->
                  let uu____6768 = FStar_TypeChecker_NBETerm.t_to_string x in
                  FStar_Util.print1 "Reading back residualtype %s\n"
                    uu____6768);
             readback cfg x) in
      let uu____6769 =
        FStar_List.map (readback_flag cfg)
          c.FStar_TypeChecker_NBETerm.residual_flags in
      {
        FStar_Syntax_Syntax.residual_effect =
          (c.FStar_TypeChecker_NBETerm.residual_effect);
        FStar_Syntax_Syntax.residual_typ = uu____6756;
        FStar_Syntax_Syntax.residual_flags = uu____6769
      }
and (translate_flag :
  config ->
    FStar_TypeChecker_NBETerm.t Prims.list ->
      FStar_Syntax_Syntax.cflag -> FStar_TypeChecker_NBETerm.cflag)
  =
  fun cfg ->
    fun bs ->
      fun f ->
        match f with
        | FStar_Syntax_Syntax.TOTAL -> FStar_TypeChecker_NBETerm.TOTAL
        | FStar_Syntax_Syntax.MLEFFECT -> FStar_TypeChecker_NBETerm.MLEFFECT
        | FStar_Syntax_Syntax.RETURN -> FStar_TypeChecker_NBETerm.RETURN
        | FStar_Syntax_Syntax.PARTIAL_RETURN ->
            FStar_TypeChecker_NBETerm.PARTIAL_RETURN
        | FStar_Syntax_Syntax.SOMETRIVIAL ->
            FStar_TypeChecker_NBETerm.SOMETRIVIAL
        | FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION ->
            FStar_TypeChecker_NBETerm.TRIVIAL_POSTCONDITION
        | FStar_Syntax_Syntax.SHOULD_NOT_INLINE ->
            FStar_TypeChecker_NBETerm.SHOULD_NOT_INLINE
        | FStar_Syntax_Syntax.LEMMA -> FStar_TypeChecker_NBETerm.LEMMA
        | FStar_Syntax_Syntax.CPS -> FStar_TypeChecker_NBETerm.CPS
        | FStar_Syntax_Syntax.DECREASES tm ->
            let uu____6780 = translate cfg bs tm in
            FStar_TypeChecker_NBETerm.DECREASES uu____6780
and (readback_flag :
  config -> FStar_TypeChecker_NBETerm.cflag -> FStar_Syntax_Syntax.cflag) =
  fun cfg ->
    fun f ->
      match f with
      | FStar_TypeChecker_NBETerm.TOTAL -> FStar_Syntax_Syntax.TOTAL
      | FStar_TypeChecker_NBETerm.MLEFFECT -> FStar_Syntax_Syntax.MLEFFECT
      | FStar_TypeChecker_NBETerm.RETURN -> FStar_Syntax_Syntax.RETURN
      | FStar_TypeChecker_NBETerm.PARTIAL_RETURN ->
          FStar_Syntax_Syntax.PARTIAL_RETURN
      | FStar_TypeChecker_NBETerm.SOMETRIVIAL ->
          FStar_Syntax_Syntax.SOMETRIVIAL
      | FStar_TypeChecker_NBETerm.TRIVIAL_POSTCONDITION ->
          FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION
      | FStar_TypeChecker_NBETerm.SHOULD_NOT_INLINE ->
          FStar_Syntax_Syntax.SHOULD_NOT_INLINE
      | FStar_TypeChecker_NBETerm.LEMMA -> FStar_Syntax_Syntax.LEMMA
      | FStar_TypeChecker_NBETerm.CPS -> FStar_Syntax_Syntax.CPS
      | FStar_TypeChecker_NBETerm.DECREASES t ->
          let uu____6784 = readback cfg t in
          FStar_Syntax_Syntax.DECREASES uu____6784
and (translate_monadic :
  (FStar_Syntax_Syntax.monad_name * FStar_Syntax_Syntax.term'
    FStar_Syntax_Syntax.syntax) ->
    config ->
      FStar_TypeChecker_NBETerm.t Prims.list ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
          FStar_TypeChecker_NBETerm.t)
  =
  fun uu____6787 ->
    fun cfg ->
      fun bs ->
        fun e ->
          match uu____6787 with
          | (m, ty) ->
              let e1 = FStar_Syntax_Util.unascribe e in
              (match e1.FStar_Syntax_Syntax.n with
               | FStar_Syntax_Syntax.Tm_let ((false, lb::[]), body) ->
                   let uu____6822 =
                     let uu____6831 =
                       FStar_TypeChecker_Env.norm_eff_name
                         (cfg.core_cfg).FStar_TypeChecker_Cfg.tcenv m in
                     FStar_TypeChecker_Env.effect_decl_opt
                       (cfg.core_cfg).FStar_TypeChecker_Cfg.tcenv uu____6831 in
                   (match uu____6822 with
                    | FStar_Pervasives_Native.None ->
                        let uu____6838 =
                          let uu____6839 = FStar_Ident.string_of_lid m in
                          FStar_Util.format1
                            "Effect declaration not found: %s" uu____6839 in
                        failwith uu____6838
                    | FStar_Pervasives_Native.Some (ed, q) ->
                        let cfg' = reifying_false cfg in
                        let body_lam =
                          let body_rc =
                            {
                              FStar_Syntax_Syntax.residual_effect = m;
                              FStar_Syntax_Syntax.residual_typ =
                                (FStar_Pervasives_Native.Some ty);
                              FStar_Syntax_Syntax.residual_flags = []
                            } in
                          let uu____6859 =
                            let uu____6860 =
                              let uu____6879 =
                                let uu____6888 =
                                  let uu____6895 =
                                    FStar_Util.left
                                      lb.FStar_Syntax_Syntax.lbname in
                                  (uu____6895, FStar_Pervasives_Native.None) in
                                [uu____6888] in
                              (uu____6879, body,
                                (FStar_Pervasives_Native.Some body_rc)) in
                            FStar_Syntax_Syntax.Tm_abs uu____6860 in
                          FStar_Syntax_Syntax.mk uu____6859
                            body.FStar_Syntax_Syntax.pos in
                        let maybe_range_arg =
                          let uu____6929 =
                            FStar_Util.for_some
                              (FStar_Syntax_Util.attr_eq
                                 FStar_Syntax_Util.dm4f_bind_range_attr)
                              ed.FStar_Syntax_Syntax.eff_attrs in
                          if uu____6929
                          then
                            let uu____6936 =
                              let uu____6941 =
                                let uu____6942 =
                                  FStar_TypeChecker_Cfg.embed_simple
                                    FStar_Syntax_Embeddings.e_range
                                    lb.FStar_Syntax_Syntax.lbpos
                                    lb.FStar_Syntax_Syntax.lbpos in
                                translate cfg [] uu____6942 in
                              (uu____6941, FStar_Pervasives_Native.None) in
                            let uu____6943 =
                              let uu____6950 =
                                let uu____6955 =
                                  let uu____6956 =
                                    FStar_TypeChecker_Cfg.embed_simple
                                      FStar_Syntax_Embeddings.e_range
                                      body.FStar_Syntax_Syntax.pos
                                      body.FStar_Syntax_Syntax.pos in
                                  translate cfg [] uu____6956 in
                                (uu____6955, FStar_Pervasives_Native.None) in
                              [uu____6950] in
                            uu____6936 :: uu____6943
                          else [] in
                        let t =
                          let uu____6975 =
                            let uu____6976 =
                              let uu____6977 =
                                let uu____6978 =
                                  let uu____6979 =
                                    let uu____6986 =
                                      FStar_All.pipe_right ed
                                        FStar_Syntax_Util.get_bind_repr in
                                    FStar_All.pipe_right uu____6986
                                      FStar_Util.must in
                                  FStar_All.pipe_right uu____6979
                                    FStar_Pervasives_Native.snd in
                                FStar_Syntax_Util.un_uinst uu____6978 in
                              translate cfg' [] uu____6977 in
                            let uu____7007 =
                              let uu____7008 =
                                let uu____7013 =
                                  FStar_All.pipe_left mk_t
                                    (FStar_TypeChecker_NBETerm.Univ
                                       FStar_Syntax_Syntax.U_unknown) in
                                (uu____7013, FStar_Pervasives_Native.None) in
                              let uu____7014 =
                                let uu____7021 =
                                  let uu____7026 =
                                    FStar_All.pipe_left mk_t
                                      (FStar_TypeChecker_NBETerm.Univ
                                         FStar_Syntax_Syntax.U_unknown) in
                                  (uu____7026, FStar_Pervasives_Native.None) in
                                [uu____7021] in
                              uu____7008 :: uu____7014 in
                            iapp cfg uu____6976 uu____7007 in
                          let uu____7039 =
                            let uu____7040 =
                              let uu____7047 =
                                let uu____7052 =
                                  translate cfg' bs
                                    lb.FStar_Syntax_Syntax.lbtyp in
                                (uu____7052, FStar_Pervasives_Native.None) in
                              let uu____7053 =
                                let uu____7060 =
                                  let uu____7065 = translate cfg' bs ty in
                                  (uu____7065, FStar_Pervasives_Native.None) in
                                [uu____7060] in
                              uu____7047 :: uu____7053 in
                            let uu____7078 =
                              let uu____7085 =
                                let uu____7092 =
                                  let uu____7099 =
                                    let uu____7104 =
                                      translate cfg bs
                                        lb.FStar_Syntax_Syntax.lbdef in
                                    (uu____7104,
                                      FStar_Pervasives_Native.None) in
                                  let uu____7105 =
                                    let uu____7112 =
                                      let uu____7119 =
                                        let uu____7124 =
                                          translate cfg bs body_lam in
                                        (uu____7124,
                                          FStar_Pervasives_Native.None) in
                                      [uu____7119] in
                                    ((mk_t FStar_TypeChecker_NBETerm.Unknown),
                                      FStar_Pervasives_Native.None) ::
                                      uu____7112 in
                                  uu____7099 :: uu____7105 in
                                ((mk_t FStar_TypeChecker_NBETerm.Unknown),
                                  FStar_Pervasives_Native.None) :: uu____7092 in
                              FStar_List.append maybe_range_arg uu____7085 in
                            FStar_List.append uu____7040 uu____7078 in
                          iapp cfg uu____6975 uu____7039 in
                        (debug cfg
                           (fun uu____7156 ->
                              let uu____7157 =
                                FStar_TypeChecker_NBETerm.t_to_string t in
                              FStar_Util.print1 "translate_monadic: %s\n"
                                uu____7157);
                         t))
               | FStar_Syntax_Syntax.Tm_app
                   ({
                      FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_constant
                        (FStar_Const.Const_reflect uu____7158);
                      FStar_Syntax_Syntax.pos = uu____7159;
                      FStar_Syntax_Syntax.vars = uu____7160;_},
                    (e2, uu____7162)::[])
                   ->
                   let uu____7201 = reifying_false cfg in
                   translate uu____7201 bs e2
               | FStar_Syntax_Syntax.Tm_app (head, args) ->
                   (debug cfg
                      (fun uu____7232 ->
                         let uu____7233 =
                           FStar_Syntax_Print.term_to_string head in
                         let uu____7234 =
                           FStar_Syntax_Print.args_to_string args in
                         FStar_Util.print2
                           "translate_monadic app (%s) @ (%s)\n" uu____7233
                           uu____7234);
                    (let fallback1 uu____7240 = translate cfg bs e1 in
                     let fallback2 uu____7246 =
                       let uu____7247 = reifying_false cfg in
                       let uu____7248 =
                         FStar_Syntax_Syntax.mk
                           (FStar_Syntax_Syntax.Tm_meta
                              (e1,
                                (FStar_Syntax_Syntax.Meta_monadic (m, ty))))
                           e1.FStar_Syntax_Syntax.pos in
                       translate uu____7247 bs uu____7248 in
                     let uu____7253 =
                       let uu____7254 = FStar_Syntax_Util.un_uinst head in
                       uu____7254.FStar_Syntax_Syntax.n in
                     match uu____7253 with
                     | FStar_Syntax_Syntax.Tm_fvar fv ->
                         let lid = FStar_Syntax_Syntax.lid_of_fv fv in
                         let qninfo =
                           FStar_TypeChecker_Env.lookup_qname
                             (cfg.core_cfg).FStar_TypeChecker_Cfg.tcenv lid in
                         let uu____7260 =
                           let uu____7261 =
                             FStar_TypeChecker_Env.is_action
                               (cfg.core_cfg).FStar_TypeChecker_Cfg.tcenv lid in
                           Prims.op_Negation uu____7261 in
                         if uu____7260
                         then fallback1 ()
                         else
                           (let uu____7263 =
                              let uu____7264 =
                                FStar_TypeChecker_Env.lookup_definition_qninfo
                                  (cfg.core_cfg).FStar_TypeChecker_Cfg.delta_level
                                  (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                  qninfo in
                              FStar_Option.isNone uu____7264 in
                            if uu____7263
                            then fallback2 ()
                            else
                              (let e2 =
                                 let uu____7277 =
                                   FStar_Syntax_Util.mk_reify head in
                                 FStar_Syntax_Syntax.mk_Tm_app uu____7277
                                   args e1.FStar_Syntax_Syntax.pos in
                               let uu____7278 = reifying_false cfg in
                               translate uu____7278 bs e2))
                     | uu____7279 -> fallback1 ()))
               | FStar_Syntax_Syntax.Tm_match (sc, branches) ->
                   let branches1 =
                     FStar_All.pipe_right branches
                       (FStar_List.map
                          (fun uu____7400 ->
                             match uu____7400 with
                             | (pat, wopt, tm) ->
                                 let uu____7448 =
                                   FStar_Syntax_Util.mk_reify tm in
                                 (pat, wopt, uu____7448))) in
                   let tm =
                     FStar_Syntax_Syntax.mk
                       (FStar_Syntax_Syntax.Tm_match (sc, branches1))
                       e1.FStar_Syntax_Syntax.pos in
                   let uu____7480 = reifying_false cfg in
                   translate uu____7480 bs tm
               | FStar_Syntax_Syntax.Tm_meta
                   (t, FStar_Syntax_Syntax.Meta_monadic uu____7482) ->
                   translate_monadic (m, ty) cfg bs e1
               | FStar_Syntax_Syntax.Tm_meta
                   (t, FStar_Syntax_Syntax.Meta_monadic_lift
                    (msrc, mtgt, ty'))
                   -> translate_monadic_lift (msrc, mtgt, ty') cfg bs e1
               | uu____7509 ->
                   let uu____7510 =
                     let uu____7511 = FStar_Syntax_Print.tag_of_term e1 in
                     FStar_Util.format1
                       "Unexpected case in translate_monadic: %s" uu____7511 in
                   failwith uu____7510)
and (translate_monadic_lift :
  (FStar_Syntax_Syntax.monad_name * FStar_Syntax_Syntax.monad_name *
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax) ->
    config ->
      FStar_TypeChecker_NBETerm.t Prims.list ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
          FStar_TypeChecker_NBETerm.t)
  =
  fun uu____7512 ->
    fun cfg ->
      fun bs ->
        fun e ->
          match uu____7512 with
          | (msrc, mtgt, ty) ->
              let e1 = FStar_Syntax_Util.unascribe e in
              let uu____7536 =
                (FStar_Syntax_Util.is_pure_effect msrc) ||
                  (FStar_Syntax_Util.is_div_effect msrc) in
              if uu____7536
              then
                let ed =
                  let uu____7538 =
                    FStar_TypeChecker_Env.norm_eff_name
                      (cfg.core_cfg).FStar_TypeChecker_Cfg.tcenv mtgt in
                  FStar_TypeChecker_Env.get_effect_decl
                    (cfg.core_cfg).FStar_TypeChecker_Cfg.tcenv uu____7538 in
                let ret =
                  let uu____7540 =
                    let uu____7541 =
                      let uu____7544 =
                        let uu____7545 =
                          let uu____7552 =
                            FStar_All.pipe_right ed
                              FStar_Syntax_Util.get_return_repr in
                          FStar_All.pipe_right uu____7552 FStar_Util.must in
                        FStar_All.pipe_right uu____7545
                          FStar_Pervasives_Native.snd in
                      FStar_Syntax_Subst.compress uu____7544 in
                    uu____7541.FStar_Syntax_Syntax.n in
                  match uu____7540 with
                  | FStar_Syntax_Syntax.Tm_uinst (ret, uu____7598::[]) ->
                      FStar_Syntax_Syntax.mk
                        (FStar_Syntax_Syntax.Tm_uinst
                           (ret, [FStar_Syntax_Syntax.U_unknown]))
                        e1.FStar_Syntax_Syntax.pos
                  | uu____7605 ->
                      failwith "NYI: Reification of indexed effect (NBE)" in
                let cfg' = reifying_false cfg in
                let t =
                  let uu____7608 =
                    let uu____7609 = translate cfg' [] ret in
                    let uu____7610 =
                      let uu____7611 =
                        let uu____7616 =
                          FStar_All.pipe_left mk_t
                            (FStar_TypeChecker_NBETerm.Univ
                               FStar_Syntax_Syntax.U_unknown) in
                        (uu____7616, FStar_Pervasives_Native.None) in
                      [uu____7611] in
                    iapp cfg' uu____7609 uu____7610 in
                  let uu____7625 =
                    let uu____7626 =
                      let uu____7631 = translate cfg' bs ty in
                      (uu____7631, FStar_Pervasives_Native.None) in
                    let uu____7632 =
                      let uu____7639 =
                        let uu____7644 = translate cfg' bs e1 in
                        (uu____7644, FStar_Pervasives_Native.None) in
                      [uu____7639] in
                    uu____7626 :: uu____7632 in
                  iapp cfg' uu____7608 uu____7625 in
                (debug cfg
                   (fun uu____7660 ->
                      let uu____7661 =
                        FStar_TypeChecker_NBETerm.t_to_string t in
                      FStar_Util.print1 "translate_monadic_lift(1): %s\n"
                        uu____7661);
                 t)
              else
                (let uu____7663 =
                   FStar_TypeChecker_Env.monad_leq
                     (cfg.core_cfg).FStar_TypeChecker_Cfg.tcenv msrc mtgt in
                 match uu____7663 with
                 | FStar_Pervasives_Native.None ->
                     let uu____7666 =
                       let uu____7667 = FStar_Ident.string_of_lid msrc in
                       let uu____7668 = FStar_Ident.string_of_lid mtgt in
                       FStar_Util.format2
                         "Impossible : trying to reify a lift between unrelated effects (%s and %s)"
                         uu____7667 uu____7668 in
                     failwith uu____7666
                 | FStar_Pervasives_Native.Some
                     { FStar_TypeChecker_Env.msource = uu____7669;
                       FStar_TypeChecker_Env.mtarget = uu____7670;
                       FStar_TypeChecker_Env.mlift =
                         { FStar_TypeChecker_Env.mlift_wp = uu____7671;
                           FStar_TypeChecker_Env.mlift_term =
                             FStar_Pervasives_Native.None;_};_}
                     ->
                     let uu____7691 =
                       let uu____7692 = FStar_Ident.string_of_lid msrc in
                       let uu____7693 = FStar_Ident.string_of_lid mtgt in
                       FStar_Util.format2
                         "Impossible : trying to reify a non-reifiable lift (from %s to %s)"
                         uu____7692 uu____7693 in
                     failwith uu____7691
                 | FStar_Pervasives_Native.Some
                     { FStar_TypeChecker_Env.msource = uu____7694;
                       FStar_TypeChecker_Env.mtarget = uu____7695;
                       FStar_TypeChecker_Env.mlift =
                         { FStar_TypeChecker_Env.mlift_wp = uu____7696;
                           FStar_TypeChecker_Env.mlift_term =
                             FStar_Pervasives_Native.Some lift;_};_}
                     ->
                     let lift_lam =
                       let x =
                         FStar_Syntax_Syntax.new_bv
                           FStar_Pervasives_Native.None
                           FStar_Syntax_Syntax.tun in
                       let uu____7730 =
                         let uu____7733 = FStar_Syntax_Syntax.bv_to_name x in
                         lift FStar_Syntax_Syntax.U_unknown ty uu____7733 in
                       FStar_Syntax_Util.abs
                         [(x, FStar_Pervasives_Native.None)] uu____7730
                         FStar_Pervasives_Native.None in
                     let cfg' = reifying_false cfg in
                     let t =
                       let uu____7750 = translate cfg' [] lift_lam in
                       let uu____7751 =
                         let uu____7752 =
                           let uu____7757 = translate cfg bs e1 in
                           (uu____7757, FStar_Pervasives_Native.None) in
                         [uu____7752] in
                       iapp cfg uu____7750 uu____7751 in
                     (debug cfg
                        (fun uu____7769 ->
                           let uu____7770 =
                             FStar_TypeChecker_NBETerm.t_to_string t in
                           FStar_Util.print1
                             "translate_monadic_lift(2): %s\n" uu____7770);
                      t))
and (readback :
  config -> FStar_TypeChecker_NBETerm.t -> FStar_Syntax_Syntax.term) =
  fun cfg ->
    fun x ->
      let debug1 = debug cfg in
      let readback_args cfg1 args =
        map_rev
          (fun uu____7822 ->
             match uu____7822 with
             | (x1, q) ->
                 let uu____7833 = readback cfg1 x1 in (uu____7833, q)) args in
      let with_range t =
        let uu___1255_7846 = t in
        {
          FStar_Syntax_Syntax.n = (uu___1255_7846.FStar_Syntax_Syntax.n);
          FStar_Syntax_Syntax.pos = (x.FStar_TypeChecker_NBETerm.nbe_r);
          FStar_Syntax_Syntax.vars =
            (uu___1255_7846.FStar_Syntax_Syntax.vars)
        } in
      let mk t = FStar_Syntax_Syntax.mk t x.FStar_TypeChecker_NBETerm.nbe_r in
      debug1
        (fun uu____7862 ->
           let uu____7863 = FStar_TypeChecker_NBETerm.t_to_string x in
           FStar_Util.print1 "Readback: %s\n" uu____7863);
      (match x.FStar_TypeChecker_NBETerm.nbe_t with
       | FStar_TypeChecker_NBETerm.Univ u ->
           failwith "Readback of universes should not occur"
       | FStar_TypeChecker_NBETerm.Unknown ->
           FStar_Syntax_Syntax.mk FStar_Syntax_Syntax.Tm_unknown
             x.FStar_TypeChecker_NBETerm.nbe_r
       | FStar_TypeChecker_NBETerm.Constant (FStar_TypeChecker_NBETerm.Unit)
           -> with_range FStar_Syntax_Syntax.unit_const
       | FStar_TypeChecker_NBETerm.Constant (FStar_TypeChecker_NBETerm.Bool
           (true)) -> with_range FStar_Syntax_Util.exp_true_bool
       | FStar_TypeChecker_NBETerm.Constant (FStar_TypeChecker_NBETerm.Bool
           (false)) -> with_range FStar_Syntax_Util.exp_false_bool
       | FStar_TypeChecker_NBETerm.Constant (FStar_TypeChecker_NBETerm.Int i)
           ->
           let uu____7866 =
             let uu____7869 = FStar_BigInt.string_of_big_int i in
             FStar_Syntax_Util.exp_int uu____7869 in
           with_range uu____7866
       | FStar_TypeChecker_NBETerm.Constant (FStar_TypeChecker_NBETerm.String
           (s, r)) ->
           mk
             (FStar_Syntax_Syntax.Tm_constant
                (FStar_Const.Const_string (s, r)))
       | FStar_TypeChecker_NBETerm.Constant (FStar_TypeChecker_NBETerm.Char
           c) ->
           let uu____7873 = FStar_Syntax_Util.exp_char c in
           with_range uu____7873
       | FStar_TypeChecker_NBETerm.Constant (FStar_TypeChecker_NBETerm.Range
           r) ->
           FStar_TypeChecker_Cfg.embed_simple FStar_Syntax_Embeddings.e_range
             x.FStar_TypeChecker_NBETerm.nbe_r r
       | FStar_TypeChecker_NBETerm.Constant (FStar_TypeChecker_NBETerm.SConst
           c) -> mk (FStar_Syntax_Syntax.Tm_constant c)
       | FStar_TypeChecker_NBETerm.Meta (t, m) ->
           let uu____7884 =
             let uu____7885 =
               let uu____7892 = readback cfg t in
               let uu____7895 = FStar_Thunk.force m in
               (uu____7892, uu____7895) in
             FStar_Syntax_Syntax.Tm_meta uu____7885 in
           mk uu____7884
       | FStar_TypeChecker_NBETerm.Type_t u ->
           mk (FStar_Syntax_Syntax.Tm_type u)
       | FStar_TypeChecker_NBETerm.Lam (f, binders, arity) ->
           let uu____7952 =
             match binders with
             | FStar_Util.Inl (ctx, binders1, rc) ->
                 let uu____8000 =
                   FStar_List.fold_left
                     (fun uu____8054 ->
                        fun uu____8055 ->
                          match (uu____8054, uu____8055) with
                          | ((ctx1, binders_rev, accus_rev), (x1, q)) ->
                              let tnorm =
                                let uu____8180 =
                                  translate cfg ctx1
                                    x1.FStar_Syntax_Syntax.sort in
                                readback cfg uu____8180 in
                              let x2 =
                                let uu___1313_8182 =
                                  FStar_Syntax_Syntax.freshen_bv x1 in
                                {
                                  FStar_Syntax_Syntax.ppname =
                                    (uu___1313_8182.FStar_Syntax_Syntax.ppname);
                                  FStar_Syntax_Syntax.index =
                                    (uu___1313_8182.FStar_Syntax_Syntax.index);
                                  FStar_Syntax_Syntax.sort = tnorm
                                } in
                              let ax = FStar_TypeChecker_NBETerm.mkAccuVar x2 in
                              let ctx2 = ax :: ctx1 in
                              (ctx2, ((x2, q) :: binders_rev), (ax ::
                                accus_rev))) (ctx, [], []) binders1 in
                 (match uu____8000 with
                  | (ctx1, binders_rev, accus_rev) ->
                      let rc1 =
                        match rc with
                        | FStar_Pervasives_Native.None ->
                            FStar_Pervasives_Native.None
                        | FStar_Pervasives_Native.Some rc1 ->
                            let uu____8268 =
                              let uu____8269 =
                                translate_residual_comp cfg ctx1 rc1 in
                              readback_residual_comp cfg uu____8269 in
                            FStar_Pervasives_Native.Some uu____8268 in
                      ((FStar_List.rev binders_rev), accus_rev, rc1))
             | FStar_Util.Inr args ->
                 let uu____8303 =
                   FStar_List.fold_right
                     (fun uu____8344 ->
                        fun uu____8345 ->
                          match (uu____8344, uu____8345) with
                          | ((t, uu____8397), (binders1, accus)) ->
                              let x1 =
                                let uu____8439 = readback cfg t in
                                FStar_Syntax_Syntax.new_bv
                                  FStar_Pervasives_Native.None uu____8439 in
                              let uu____8440 =
                                let uu____8443 =
                                  FStar_TypeChecker_NBETerm.mkAccuVar x1 in
                                uu____8443 :: accus in
                              (((x1, FStar_Pervasives_Native.None) ::
                                binders1), uu____8440)) args ([], []) in
                 (match uu____8303 with
                  | (binders1, accus) ->
                      (binders1, (FStar_List.rev accus),
                        FStar_Pervasives_Native.None)) in
           (match uu____7952 with
            | (binders1, accus_rev, rc) ->
                let body =
                  let uu____8526 = f accus_rev in readback cfg uu____8526 in
                let uu____8527 = FStar_Syntax_Util.abs binders1 body rc in
                with_range uu____8527)
       | FStar_TypeChecker_NBETerm.Refinement (f, targ) ->
           if
             ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.for_extraction
           then
             let uu____8552 =
               let uu____8553 = targ () in
               FStar_Pervasives_Native.fst uu____8553 in
             readback cfg uu____8552
           else
             (let x1 =
                let uu____8560 =
                  let uu____8561 =
                    let uu____8562 = targ () in
                    FStar_Pervasives_Native.fst uu____8562 in
                  readback cfg uu____8561 in
                FStar_Syntax_Syntax.new_bv FStar_Pervasives_Native.None
                  uu____8560 in
              let body =
                let uu____8568 =
                  let uu____8569 = FStar_TypeChecker_NBETerm.mkAccuVar x1 in
                  f uu____8569 in
                readback cfg uu____8568 in
              let refinement = FStar_Syntax_Util.refine x1 body in
              let uu____8573 =
                if
                  ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.simplify
                then
                  FStar_TypeChecker_Common.simplify
                    ((cfg.core_cfg).FStar_TypeChecker_Cfg.debug).FStar_TypeChecker_Cfg.wpe
                    refinement
                else refinement in
              with_range uu____8573)
       | FStar_TypeChecker_NBETerm.Reflect t ->
           let tm = readback cfg t in
           let uu____8581 = FStar_Syntax_Util.mk_reflect tm in
           with_range uu____8581
       | FStar_TypeChecker_NBETerm.Arrow (FStar_Util.Inl f) ->
           let uu____8599 = FStar_Thunk.force f in with_range uu____8599
       | FStar_TypeChecker_NBETerm.Arrow (FStar_Util.Inr (args, c)) ->
           let binders =
             FStar_List.map
               (fun uu____8648 ->
                  match uu____8648 with
                  | (t, q) ->
                      let t1 = readback cfg t in
                      let x1 =
                        FStar_Syntax_Syntax.new_bv
                          FStar_Pervasives_Native.None t1 in
                      (x1, q)) args in
           let c1 = readback_comp cfg c in
           let uu____8662 = FStar_Syntax_Util.arrow binders c1 in
           with_range uu____8662
       | FStar_TypeChecker_NBETerm.Construct (fv, us, args) ->
           let args1 =
             map_rev
               (fun uu____8703 ->
                  match uu____8703 with
                  | (x1, q) ->
                      let uu____8714 = readback cfg x1 in (uu____8714, q))
               args in
           let fv1 =
             let uu____8718 = FStar_Syntax_Syntax.range_of_fv fv in
             FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_fvar fv)
               uu____8718 in
           let app =
             let uu____8722 =
               FStar_Syntax_Syntax.mk_Tm_uinst fv1 (FStar_List.rev us) in
             FStar_Syntax_Util.mk_app uu____8722 args1 in
           with_range app
       | FStar_TypeChecker_NBETerm.FV (fv, us, args) ->
           let args1 =
             map_rev
               (fun uu____8763 ->
                  match uu____8763 with
                  | (x1, q) ->
                      let uu____8774 = readback cfg x1 in (uu____8774, q))
               args in
           let fv1 =
             FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_fvar fv)
               FStar_Range.dummyRange in
           let app =
             let uu____8781 =
               FStar_Syntax_Syntax.mk_Tm_uinst fv1 (FStar_List.rev us) in
             FStar_Syntax_Util.mk_app uu____8781 args1 in
           let uu____8784 =
             if
               ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.simplify
             then
               FStar_TypeChecker_Common.simplify
                 ((cfg.core_cfg).FStar_TypeChecker_Cfg.debug).FStar_TypeChecker_Cfg.wpe
                 app
             else app in
           with_range uu____8784
       | FStar_TypeChecker_NBETerm.Accu
           (FStar_TypeChecker_NBETerm.Var bv, []) ->
           let uu____8801 = FStar_Syntax_Syntax.bv_to_name bv in
           with_range uu____8801
       | FStar_TypeChecker_NBETerm.Accu
           (FStar_TypeChecker_NBETerm.Var bv, args) ->
           let args1 = readback_args cfg args in
           let app =
             let uu____8828 = FStar_Syntax_Syntax.bv_to_name bv in
             FStar_Syntax_Util.mk_app uu____8828 args1 in
           let uu____8831 =
             if
               ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.simplify
             then
               FStar_TypeChecker_Common.simplify
                 ((cfg.core_cfg).FStar_TypeChecker_Cfg.debug).FStar_TypeChecker_Cfg.wpe
                 app
             else app in
           with_range uu____8831
       | FStar_TypeChecker_NBETerm.Accu
           (FStar_TypeChecker_NBETerm.Match (scrut, make_branches), args) ->
           let args1 = readback_args cfg args in
           let head =
             let scrut_new = readback cfg scrut in
             let branches_new = make_branches () in
             FStar_Syntax_Syntax.mk
               (FStar_Syntax_Syntax.Tm_match (scrut_new, branches_new))
               scrut.FStar_TypeChecker_NBETerm.nbe_r in
           let app = FStar_Syntax_Util.mk_app head args1 in
           let uu____8897 =
             if
               ((cfg.core_cfg).FStar_TypeChecker_Cfg.steps).FStar_TypeChecker_Cfg.simplify
             then
               FStar_TypeChecker_Common.simplify
                 ((cfg.core_cfg).FStar_TypeChecker_Cfg.debug).FStar_TypeChecker_Cfg.wpe
                 app
             else app in
           with_range uu____8897
       | FStar_TypeChecker_NBETerm.Accu
           (FStar_TypeChecker_NBETerm.UnreducedLet
            (var, typ, defn, body, lb), args)
           ->
           let typ1 =
             let uu____8934 = FStar_Thunk.force typ in
             readback cfg uu____8934 in
           let defn1 =
             let uu____8936 = FStar_Thunk.force defn in
             readback cfg uu____8936 in
           let body1 =
             let uu____8938 =
               let uu____8939 = FStar_Thunk.force body in
               readback cfg uu____8939 in
             FStar_Syntax_Subst.close [(var, FStar_Pervasives_Native.None)]
               uu____8938 in
           let lbname =
             let uu____8959 =
               let uu___1432_8960 =
                 FStar_Util.left lb.FStar_Syntax_Syntax.lbname in
               {
                 FStar_Syntax_Syntax.ppname =
                   (uu___1432_8960.FStar_Syntax_Syntax.ppname);
                 FStar_Syntax_Syntax.index =
                   (uu___1432_8960.FStar_Syntax_Syntax.index);
                 FStar_Syntax_Syntax.sort = typ1
               } in
             FStar_Util.Inl uu____8959 in
           let lb1 =
             let uu___1435_8962 = lb in
             {
               FStar_Syntax_Syntax.lbname = lbname;
               FStar_Syntax_Syntax.lbunivs =
                 (uu___1435_8962.FStar_Syntax_Syntax.lbunivs);
               FStar_Syntax_Syntax.lbtyp = typ1;
               FStar_Syntax_Syntax.lbeff =
                 (uu___1435_8962.FStar_Syntax_Syntax.lbeff);
               FStar_Syntax_Syntax.lbdef = defn1;
               FStar_Syntax_Syntax.lbattrs =
                 (uu___1435_8962.FStar_Syntax_Syntax.lbattrs);
               FStar_Syntax_Syntax.lbpos =
                 (uu___1435_8962.FStar_Syntax_Syntax.lbpos)
             } in
           let hd =
             FStar_Syntax_Syntax.mk
               (FStar_Syntax_Syntax.Tm_let ((false, [lb1]), body1))
               FStar_Range.dummyRange in
           let args1 = readback_args cfg args in
           let uu____8983 = FStar_Syntax_Util.mk_app hd args1 in
           with_range uu____8983
       | FStar_TypeChecker_NBETerm.Accu
           (FStar_TypeChecker_NBETerm.UnreducedLetRec
            (vars_typs_defns, body, lbs), args)
           ->
           let lbs1 =
             FStar_List.map2
               (fun uu____9040 ->
                  fun lb ->
                    match uu____9040 with
                    | (v, t, d) ->
                        let t1 = readback cfg t in
                        let def = readback cfg d in
                        let v1 =
                          let uu___1455_9054 = v in
                          {
                            FStar_Syntax_Syntax.ppname =
                              (uu___1455_9054.FStar_Syntax_Syntax.ppname);
                            FStar_Syntax_Syntax.index =
                              (uu___1455_9054.FStar_Syntax_Syntax.index);
                            FStar_Syntax_Syntax.sort = t1
                          } in
                        let uu___1458_9055 = lb in
                        {
                          FStar_Syntax_Syntax.lbname = (FStar_Util.Inl v1);
                          FStar_Syntax_Syntax.lbunivs =
                            (uu___1458_9055.FStar_Syntax_Syntax.lbunivs);
                          FStar_Syntax_Syntax.lbtyp = t1;
                          FStar_Syntax_Syntax.lbeff =
                            (uu___1458_9055.FStar_Syntax_Syntax.lbeff);
                          FStar_Syntax_Syntax.lbdef = def;
                          FStar_Syntax_Syntax.lbattrs =
                            (uu___1458_9055.FStar_Syntax_Syntax.lbattrs);
                          FStar_Syntax_Syntax.lbpos =
                            (uu___1458_9055.FStar_Syntax_Syntax.lbpos)
                        }) vars_typs_defns lbs in
           let body1 = readback cfg body in
           let uu____9057 = FStar_Syntax_Subst.close_let_rec lbs1 body1 in
           (match uu____9057 with
            | (lbs2, body2) ->
                let hd =
                  FStar_Syntax_Syntax.mk
                    (FStar_Syntax_Syntax.Tm_let ((true, lbs2), body2))
                    FStar_Range.dummyRange in
                let args1 = readback_args cfg args in
                let uu____9090 = FStar_Syntax_Util.mk_app hd args1 in
                with_range uu____9090)
       | FStar_TypeChecker_NBETerm.Accu
           (FStar_TypeChecker_NBETerm.UVar f, args) ->
           let hd = FStar_Thunk.force f in
           let args1 = readback_args cfg args in
           let uu____9117 = FStar_Syntax_Util.mk_app hd args1 in
           with_range uu____9117
       | FStar_TypeChecker_NBETerm.TopLevelLet (lb, arity, args_rev) ->
           let n_univs = FStar_List.length lb.FStar_Syntax_Syntax.lbunivs in
           let n_args = FStar_List.length args_rev in
           let uu____9141 = FStar_Util.first_N (n_args - n_univs) args_rev in
           (match uu____9141 with
            | (args_rev1, univs) ->
                let uu____9188 =
                  let uu____9189 =
                    let uu____9190 =
                      FStar_List.map FStar_Pervasives_Native.fst univs in
                    translate cfg uu____9190 lb.FStar_Syntax_Syntax.lbdef in
                  iapp cfg uu____9189 (FStar_List.rev args_rev1) in
                readback cfg uu____9188)
       | FStar_TypeChecker_NBETerm.TopLevelRec
           (lb, uu____9202, uu____9203, args) ->
           let fv = FStar_Util.right lb.FStar_Syntax_Syntax.lbname in
           let head =
             FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_fvar fv)
               FStar_Range.dummyRange in
           let args1 =
             FStar_List.map
               (fun uu____9244 ->
                  match uu____9244 with
                  | (t, q) ->
                      let uu____9255 = readback cfg t in (uu____9255, q))
               args in
           let uu____9256 = FStar_Syntax_Util.mk_app head args1 in
           with_range uu____9256
       | FStar_TypeChecker_NBETerm.LocalLetRec
           (i, uu____9260, lbs, bs, args, _ar, _ar_lst) ->
           let lbnames =
             FStar_List.map
               (fun lb ->
                  let uu____9296 =
                    let uu____9297 =
                      let uu____9298 =
                        FStar_Util.left lb.FStar_Syntax_Syntax.lbname in
                      uu____9298.FStar_Syntax_Syntax.ppname in
                    FStar_Ident.string_of_id uu____9297 in
                  FStar_Syntax_Syntax.gen_bv uu____9296
                    FStar_Pervasives_Native.None lb.FStar_Syntax_Syntax.lbtyp)
               lbs in
           let let_rec_env =
             let uu____9302 =
               FStar_List.map
                 (fun x1 ->
                    let uu____9308 = FStar_Syntax_Syntax.range_of_bv x1 in
                    mk_rt uu____9308
                      (FStar_TypeChecker_NBETerm.Accu
                         ((FStar_TypeChecker_NBETerm.Var x1), []))) lbnames in
             FStar_List.rev_append uu____9302 bs in
           let lbs1 =
             FStar_List.map2
               (fun lb ->
                  fun lbname ->
                    let lbdef =
                      let uu____9330 =
                        translate cfg let_rec_env
                          lb.FStar_Syntax_Syntax.lbdef in
                      readback cfg uu____9330 in
                    let lbtyp =
                      let uu____9332 =
                        translate cfg bs lb.FStar_Syntax_Syntax.lbtyp in
                      readback cfg uu____9332 in
                    let uu___1513_9333 = lb in
                    {
                      FStar_Syntax_Syntax.lbname = (FStar_Util.Inl lbname);
                      FStar_Syntax_Syntax.lbunivs =
                        (uu___1513_9333.FStar_Syntax_Syntax.lbunivs);
                      FStar_Syntax_Syntax.lbtyp = lbtyp;
                      FStar_Syntax_Syntax.lbeff =
                        (uu___1513_9333.FStar_Syntax_Syntax.lbeff);
                      FStar_Syntax_Syntax.lbdef = lbdef;
                      FStar_Syntax_Syntax.lbattrs =
                        (uu___1513_9333.FStar_Syntax_Syntax.lbattrs);
                      FStar_Syntax_Syntax.lbpos =
                        (uu___1513_9333.FStar_Syntax_Syntax.lbpos)
                    }) lbs lbnames in
           let body =
             let uu____9335 = FStar_List.nth lbnames i in
             FStar_Syntax_Syntax.bv_to_name uu____9335 in
           let uu____9336 = FStar_Syntax_Subst.close_let_rec lbs1 body in
           (match uu____9336 with
            | (lbs2, body1) ->
                let head =
                  FStar_Syntax_Syntax.mk
                    (FStar_Syntax_Syntax.Tm_let ((true, lbs2), body1))
                    FStar_Range.dummyRange in
                let args1 =
                  FStar_List.map
                    (fun uu____9381 ->
                       match uu____9381 with
                       | (x1, q) ->
                           let uu____9392 = readback cfg x1 in
                           (uu____9392, q)) args in
                let uu____9393 = FStar_Syntax_Util.mk_app head args1 in
                with_range uu____9393)
       | FStar_TypeChecker_NBETerm.Quote (qt, qi) ->
           mk (FStar_Syntax_Syntax.Tm_quoted (qt, qi))
       | FStar_TypeChecker_NBETerm.Lazy (FStar_Util.Inl li, uu____9401) ->
           mk (FStar_Syntax_Syntax.Tm_lazy li)
       | FStar_TypeChecker_NBETerm.Lazy (uu____9418, thunk) ->
           let uu____9440 = FStar_Thunk.force thunk in
           readback cfg uu____9440)
type step =
  | Primops 
  | UnfoldUntil of FStar_Syntax_Syntax.delta_depth 
  | UnfoldOnly of FStar_Ident.lid Prims.list 
  | UnfoldAttr of FStar_Ident.lid Prims.list 
  | UnfoldTac 
  | Reify 
let (uu___is_Primops : step -> Prims.bool) =
  fun projectee ->
    match projectee with | Primops -> true | uu____9465 -> false
let (uu___is_UnfoldUntil : step -> Prims.bool) =
  fun projectee ->
    match projectee with | UnfoldUntil _0 -> true | uu____9472 -> false
let (__proj__UnfoldUntil__item___0 : step -> FStar_Syntax_Syntax.delta_depth)
  = fun projectee -> match projectee with | UnfoldUntil _0 -> _0
let (uu___is_UnfoldOnly : step -> Prims.bool) =
  fun projectee ->
    match projectee with | UnfoldOnly _0 -> true | uu____9487 -> false
let (__proj__UnfoldOnly__item___0 : step -> FStar_Ident.lid Prims.list) =
  fun projectee -> match projectee with | UnfoldOnly _0 -> _0
let (uu___is_UnfoldAttr : step -> Prims.bool) =
  fun projectee ->
    match projectee with | UnfoldAttr _0 -> true | uu____9508 -> false
let (__proj__UnfoldAttr__item___0 : step -> FStar_Ident.lid Prims.list) =
  fun projectee -> match projectee with | UnfoldAttr _0 -> _0
let (uu___is_UnfoldTac : step -> Prims.bool) =
  fun projectee ->
    match projectee with | UnfoldTac -> true | uu____9526 -> false
let (uu___is_Reify : step -> Prims.bool) =
  fun projectee -> match projectee with | Reify -> true | uu____9532 -> false
let (step_as_normalizer_step : step -> FStar_TypeChecker_Env.step) =
  fun uu___2_9537 ->
    match uu___2_9537 with
    | Primops -> FStar_TypeChecker_Env.Primops
    | UnfoldUntil d -> FStar_TypeChecker_Env.UnfoldUntil d
    | UnfoldOnly lids -> FStar_TypeChecker_Env.UnfoldOnly lids
    | UnfoldAttr lids -> FStar_TypeChecker_Env.UnfoldAttr lids
    | UnfoldTac -> FStar_TypeChecker_Env.UnfoldTac
    | Reify -> FStar_TypeChecker_Env.Reify
let (reduce_application :
  FStar_TypeChecker_Cfg.cfg ->
    FStar_TypeChecker_NBETerm.t ->
      FStar_TypeChecker_NBETerm.args -> FStar_TypeChecker_NBETerm.t)
  =
  fun cfg ->
    fun t ->
      fun args -> let uu____9560 = new_config cfg in iapp uu____9560 t args
let (normalize :
  FStar_TypeChecker_Cfg.primitive_step Prims.list ->
    FStar_TypeChecker_Env.step Prims.list ->
      FStar_TypeChecker_Env.env ->
        FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun psteps ->
    fun steps ->
      fun env ->
        fun e ->
          let cfg = FStar_TypeChecker_Cfg.config' psteps steps env in
          let cfg1 =
            let uu___1559_9591 = cfg in
            {
              FStar_TypeChecker_Cfg.steps =
                (let uu___1561_9594 = cfg.FStar_TypeChecker_Cfg.steps in
                 {
                   FStar_TypeChecker_Cfg.beta =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.beta);
                   FStar_TypeChecker_Cfg.iota =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.iota);
                   FStar_TypeChecker_Cfg.zeta =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.zeta);
                   FStar_TypeChecker_Cfg.zeta_full =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.zeta_full);
                   FStar_TypeChecker_Cfg.weak =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.weak);
                   FStar_TypeChecker_Cfg.hnf =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.hnf);
                   FStar_TypeChecker_Cfg.primops =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.primops);
                   FStar_TypeChecker_Cfg.do_not_unfold_pure_lets =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.do_not_unfold_pure_lets);
                   FStar_TypeChecker_Cfg.unfold_until =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.unfold_until);
                   FStar_TypeChecker_Cfg.unfold_only =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.unfold_only);
                   FStar_TypeChecker_Cfg.unfold_fully =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.unfold_fully);
                   FStar_TypeChecker_Cfg.unfold_attr =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.unfold_attr);
                   FStar_TypeChecker_Cfg.unfold_tac =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.unfold_tac);
                   FStar_TypeChecker_Cfg.pure_subterms_within_computations =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.pure_subterms_within_computations);
                   FStar_TypeChecker_Cfg.simplify =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.simplify);
                   FStar_TypeChecker_Cfg.erase_universes =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.erase_universes);
                   FStar_TypeChecker_Cfg.allow_unbound_universes =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.allow_unbound_universes);
                   FStar_TypeChecker_Cfg.reify_ = true;
                   FStar_TypeChecker_Cfg.compress_uvars =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.compress_uvars);
                   FStar_TypeChecker_Cfg.no_full_norm =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.no_full_norm);
                   FStar_TypeChecker_Cfg.check_no_uvars =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.check_no_uvars);
                   FStar_TypeChecker_Cfg.unmeta =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.unmeta);
                   FStar_TypeChecker_Cfg.unascribe =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.unascribe);
                   FStar_TypeChecker_Cfg.in_full_norm_request =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.in_full_norm_request);
                   FStar_TypeChecker_Cfg.weakly_reduce_scrutinee =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.weakly_reduce_scrutinee);
                   FStar_TypeChecker_Cfg.nbe_step =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.nbe_step);
                   FStar_TypeChecker_Cfg.for_extraction =
                     (uu___1561_9594.FStar_TypeChecker_Cfg.for_extraction)
                 });
              FStar_TypeChecker_Cfg.tcenv =
                (uu___1559_9591.FStar_TypeChecker_Cfg.tcenv);
              FStar_TypeChecker_Cfg.debug =
                (uu___1559_9591.FStar_TypeChecker_Cfg.debug);
              FStar_TypeChecker_Cfg.delta_level =
                (uu___1559_9591.FStar_TypeChecker_Cfg.delta_level);
              FStar_TypeChecker_Cfg.primitive_steps =
                (uu___1559_9591.FStar_TypeChecker_Cfg.primitive_steps);
              FStar_TypeChecker_Cfg.strong =
                (uu___1559_9591.FStar_TypeChecker_Cfg.strong);
              FStar_TypeChecker_Cfg.memoize_lazy =
                (uu___1559_9591.FStar_TypeChecker_Cfg.memoize_lazy);
              FStar_TypeChecker_Cfg.normalize_pure_lets =
                (uu___1559_9591.FStar_TypeChecker_Cfg.normalize_pure_lets);
              FStar_TypeChecker_Cfg.reifying =
                (uu___1559_9591.FStar_TypeChecker_Cfg.reifying)
            } in
          (let uu____9596 =
             (FStar_TypeChecker_Env.debug env (FStar_Options.Other "NBETop"))
               ||
               (FStar_TypeChecker_Env.debug env (FStar_Options.Other "NBE")) in
           if uu____9596
           then
             let uu____9597 = FStar_Syntax_Print.term_to_string e in
             FStar_Util.print1 "Calling NBE with (%s) {\n" uu____9597
           else ());
          (let cfg2 = new_config cfg1 in
           let r =
             let uu____9601 = translate cfg2 [] e in readback cfg2 uu____9601 in
           (let uu____9603 =
              (FStar_TypeChecker_Env.debug env (FStar_Options.Other "NBETop"))
                ||
                (FStar_TypeChecker_Env.debug env (FStar_Options.Other "NBE")) in
            if uu____9603
            then
              let uu____9604 = FStar_Syntax_Print.term_to_string r in
              FStar_Util.print1 "}\nNBE returned (%s)\n" uu____9604
            else ());
           r)
let (normalize_for_unit_test :
  FStar_TypeChecker_Env.step Prims.list ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun steps ->
    fun env ->
      fun e ->
        let cfg = FStar_TypeChecker_Cfg.config steps env in
        let cfg1 =
          let uu___1577_9627 = cfg in
          {
            FStar_TypeChecker_Cfg.steps =
              (let uu___1579_9630 = cfg.FStar_TypeChecker_Cfg.steps in
               {
                 FStar_TypeChecker_Cfg.beta =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.beta);
                 FStar_TypeChecker_Cfg.iota =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.iota);
                 FStar_TypeChecker_Cfg.zeta =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.zeta);
                 FStar_TypeChecker_Cfg.zeta_full =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.zeta_full);
                 FStar_TypeChecker_Cfg.weak =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.weak);
                 FStar_TypeChecker_Cfg.hnf =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.hnf);
                 FStar_TypeChecker_Cfg.primops =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.primops);
                 FStar_TypeChecker_Cfg.do_not_unfold_pure_lets =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.do_not_unfold_pure_lets);
                 FStar_TypeChecker_Cfg.unfold_until =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.unfold_until);
                 FStar_TypeChecker_Cfg.unfold_only =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.unfold_only);
                 FStar_TypeChecker_Cfg.unfold_fully =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.unfold_fully);
                 FStar_TypeChecker_Cfg.unfold_attr =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.unfold_attr);
                 FStar_TypeChecker_Cfg.unfold_tac =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.unfold_tac);
                 FStar_TypeChecker_Cfg.pure_subterms_within_computations =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.pure_subterms_within_computations);
                 FStar_TypeChecker_Cfg.simplify =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.simplify);
                 FStar_TypeChecker_Cfg.erase_universes =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.erase_universes);
                 FStar_TypeChecker_Cfg.allow_unbound_universes =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.allow_unbound_universes);
                 FStar_TypeChecker_Cfg.reify_ = true;
                 FStar_TypeChecker_Cfg.compress_uvars =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.compress_uvars);
                 FStar_TypeChecker_Cfg.no_full_norm =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.no_full_norm);
                 FStar_TypeChecker_Cfg.check_no_uvars =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.check_no_uvars);
                 FStar_TypeChecker_Cfg.unmeta =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.unmeta);
                 FStar_TypeChecker_Cfg.unascribe =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.unascribe);
                 FStar_TypeChecker_Cfg.in_full_norm_request =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.in_full_norm_request);
                 FStar_TypeChecker_Cfg.weakly_reduce_scrutinee =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.weakly_reduce_scrutinee);
                 FStar_TypeChecker_Cfg.nbe_step =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.nbe_step);
                 FStar_TypeChecker_Cfg.for_extraction =
                   (uu___1579_9630.FStar_TypeChecker_Cfg.for_extraction)
               });
            FStar_TypeChecker_Cfg.tcenv =
              (uu___1577_9627.FStar_TypeChecker_Cfg.tcenv);
            FStar_TypeChecker_Cfg.debug =
              (uu___1577_9627.FStar_TypeChecker_Cfg.debug);
            FStar_TypeChecker_Cfg.delta_level =
              (uu___1577_9627.FStar_TypeChecker_Cfg.delta_level);
            FStar_TypeChecker_Cfg.primitive_steps =
              (uu___1577_9627.FStar_TypeChecker_Cfg.primitive_steps);
            FStar_TypeChecker_Cfg.strong =
              (uu___1577_9627.FStar_TypeChecker_Cfg.strong);
            FStar_TypeChecker_Cfg.memoize_lazy =
              (uu___1577_9627.FStar_TypeChecker_Cfg.memoize_lazy);
            FStar_TypeChecker_Cfg.normalize_pure_lets =
              (uu___1577_9627.FStar_TypeChecker_Cfg.normalize_pure_lets);
            FStar_TypeChecker_Cfg.reifying =
              (uu___1577_9627.FStar_TypeChecker_Cfg.reifying)
          } in
        let cfg2 = new_config cfg1 in
        debug cfg2
          (fun uu____9635 ->
             let uu____9636 = FStar_Syntax_Print.term_to_string e in
             FStar_Util.print1 "Calling NBE with (%s) {\n" uu____9636);
        (let r =
           let uu____9638 = translate cfg2 [] e in readback cfg2 uu____9638 in
         debug cfg2
           (fun uu____9642 ->
              let uu____9643 = FStar_Syntax_Print.term_to_string r in
              FStar_Util.print1 "}\nNBE returned (%s)\n" uu____9643);
         r)