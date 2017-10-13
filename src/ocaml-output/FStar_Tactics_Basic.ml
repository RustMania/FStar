open Prims
type name = FStar_Syntax_Syntax.bv[@@deriving show]
type env = FStar_TypeChecker_Env.env[@@deriving show]
type implicits = FStar_TypeChecker_Env.implicits[@@deriving show]
let normalize:
  FStar_TypeChecker_Normalize.step Prims.list ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun s  ->
    fun e  ->
      fun t  ->
        FStar_TypeChecker_Normalize.normalize_with_primitive_steps
          FStar_Reflection_Interpreter.reflection_primops s e t
let bnorm:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  = fun e  -> fun t  -> normalize [] e t
type 'a tac =
  {
  tac_f: FStar_Tactics_Types.proofstate -> 'a FStar_Tactics_Result.__result;}
[@@deriving show]
let __proj__Mktac__item__tac_f:
  'a .
    'a tac ->
      FStar_Tactics_Types.proofstate -> 'a FStar_Tactics_Result.__result
  =
  fun projectee  ->
    match projectee with | { tac_f = __fname__tac_f;_} -> __fname__tac_f
let mk_tac:
  'a .
    (FStar_Tactics_Types.proofstate -> 'a FStar_Tactics_Result.__result) ->
      'a tac
  = fun f  -> { tac_f = f }
let run:
  'Auu____88 .
    'Auu____88 tac ->
      FStar_Tactics_Types.proofstate ->
        'Auu____88 FStar_Tactics_Result.__result
  = fun t  -> fun p  -> t.tac_f p
let ret: 'a . 'a -> 'a tac =
  fun x  -> mk_tac (fun p  -> FStar_Tactics_Result.Success (x, p))
let bind: 'a 'b . 'a tac -> ('a -> 'b tac) -> 'b tac =
  fun t1  ->
    fun t2  ->
      mk_tac
        (fun p  ->
           let uu____155 = run t1 p in
           match uu____155 with
           | FStar_Tactics_Result.Success (a,q) ->
               let uu____162 = t2 a in run uu____162 q
           | FStar_Tactics_Result.Failed (msg,q) ->
               FStar_Tactics_Result.Failed (msg, q))
let idtac: Prims.unit tac = ret ()
let goal_to_string: FStar_Tactics_Types.goal -> Prims.string =
  fun g  ->
    let g_binders =
      let uu____174 =
        FStar_TypeChecker_Env.all_binders g.FStar_Tactics_Types.context in
      FStar_All.pipe_right uu____174
        (FStar_Syntax_Print.binders_to_string ", ") in
    let w = bnorm g.FStar_Tactics_Types.context g.FStar_Tactics_Types.witness in
    let t = bnorm g.FStar_Tactics_Types.context g.FStar_Tactics_Types.goal_ty in
    let uu____177 =
      FStar_TypeChecker_Normalize.term_to_string
        g.FStar_Tactics_Types.context w in
    let uu____178 =
      FStar_TypeChecker_Normalize.term_to_string
        g.FStar_Tactics_Types.context t in
    FStar_Util.format3 "%s |- %s : %s" g_binders uu____177 uu____178
let tacprint: Prims.string -> Prims.unit =
  fun s  -> FStar_Util.print1 "TAC>> %s\n" s
let tacprint1: Prims.string -> Prims.string -> Prims.unit =
  fun s  ->
    fun x  ->
      let uu____191 = FStar_Util.format1 s x in
      FStar_Util.print1 "TAC>> %s\n" uu____191
let tacprint2: Prims.string -> Prims.string -> Prims.string -> Prims.unit =
  fun s  ->
    fun x  ->
      fun y  ->
        let uu____204 = FStar_Util.format2 s x y in
        FStar_Util.print1 "TAC>> %s\n" uu____204
let tacprint3:
  Prims.string -> Prims.string -> Prims.string -> Prims.string -> Prims.unit
  =
  fun s  ->
    fun x  ->
      fun y  ->
        fun z  ->
          let uu____221 = FStar_Util.format3 s x y z in
          FStar_Util.print1 "TAC>> %s\n" uu____221
let comp_to_typ: FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.typ =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total (t,uu____227) -> t
    | FStar_Syntax_Syntax.GTotal (t,uu____237) -> t
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.result_typ
let is_irrelevant: FStar_Tactics_Types.goal -> Prims.bool =
  fun g  ->
    let uu____251 =
      let uu____256 =
        FStar_TypeChecker_Normalize.unfold_whnf g.FStar_Tactics_Types.context
          g.FStar_Tactics_Types.goal_ty in
      FStar_Syntax_Util.un_squash uu____256 in
    match uu____251 with
    | FStar_Pervasives_Native.Some t -> true
    | uu____262 -> false
let dump_goal:
  'Auu____273 . 'Auu____273 -> FStar_Tactics_Types.goal -> Prims.unit =
  fun ps  ->
    fun goal  -> let uu____283 = goal_to_string goal in tacprint uu____283
let dump_cur: FStar_Tactics_Types.proofstate -> Prims.string -> Prims.unit =
  fun ps  ->
    fun msg  ->
      match ps.FStar_Tactics_Types.goals with
      | [] -> tacprint1 "No more goals (%s)" msg
      | h::uu____293 ->
          (tacprint1 "Current goal (%s):" msg;
           (let uu____297 = FStar_List.hd ps.FStar_Tactics_Types.goals in
            dump_goal ps uu____297))
let ps_to_string:
  (Prims.string,FStar_Tactics_Types.proofstate)
    FStar_Pervasives_Native.tuple2 -> Prims.string
  =
  fun uu____305  ->
    match uu____305 with
    | (msg,ps) ->
        let uu____312 = FStar_Util.string_of_int ps.FStar_Tactics_Types.depth in
        let uu____313 =
          FStar_Util.string_of_int
            (FStar_List.length ps.FStar_Tactics_Types.goals) in
        let uu____314 =
          let uu____315 =
            FStar_List.map goal_to_string ps.FStar_Tactics_Types.goals in
          FStar_String.concat "\n" uu____315 in
        let uu____318 =
          FStar_Util.string_of_int
            (FStar_List.length ps.FStar_Tactics_Types.smt_goals) in
        let uu____319 =
          let uu____320 =
            FStar_List.map goal_to_string ps.FStar_Tactics_Types.smt_goals in
          FStar_String.concat "\n" uu____320 in
        FStar_Util.format6
          "State dump @ depth %s(%s):\nACTIVE goals (%s):\n%s\nSMT goals (%s):\n%s"
          uu____312 msg uu____313 uu____314 uu____318 uu____319
let goal_to_json: FStar_Tactics_Types.goal -> FStar_Util.json =
  fun g  ->
    let g_binders =
      let uu____328 =
        FStar_TypeChecker_Env.all_binders g.FStar_Tactics_Types.context in
      FStar_All.pipe_right uu____328 FStar_Syntax_Print.binders_to_json in
    let uu____329 =
      let uu____336 =
        let uu____343 =
          let uu____348 =
            let uu____349 =
              let uu____356 =
                let uu____361 =
                  let uu____362 =
                    FStar_TypeChecker_Normalize.term_to_string
                      g.FStar_Tactics_Types.context
                      g.FStar_Tactics_Types.witness in
                  FStar_Util.JsonStr uu____362 in
                ("witness", uu____361) in
              let uu____363 =
                let uu____370 =
                  let uu____375 =
                    let uu____376 =
                      FStar_TypeChecker_Normalize.term_to_string
                        g.FStar_Tactics_Types.context
                        g.FStar_Tactics_Types.goal_ty in
                    FStar_Util.JsonStr uu____376 in
                  ("type", uu____375) in
                [uu____370] in
              uu____356 :: uu____363 in
            FStar_Util.JsonAssoc uu____349 in
          ("goal", uu____348) in
        [uu____343] in
      ("hyps", g_binders) :: uu____336 in
    FStar_Util.JsonAssoc uu____329
let ps_to_json:
  (Prims.string,FStar_Tactics_Types.proofstate)
    FStar_Pervasives_Native.tuple2 -> FStar_Util.json
  =
  fun uu____408  ->
    match uu____408 with
    | (msg,ps) ->
        let uu____415 =
          let uu____422 =
            let uu____429 =
              let uu____434 =
                let uu____435 =
                  FStar_List.map goal_to_json ps.FStar_Tactics_Types.goals in
                FStar_Util.JsonList uu____435 in
              ("goals", uu____434) in
            let uu____438 =
              let uu____445 =
                let uu____450 =
                  let uu____451 =
                    FStar_List.map goal_to_json
                      ps.FStar_Tactics_Types.smt_goals in
                  FStar_Util.JsonList uu____451 in
                ("smt-goals", uu____450) in
              [uu____445] in
            uu____429 :: uu____438 in
          ("label", (FStar_Util.JsonStr msg)) :: uu____422 in
        FStar_Util.JsonAssoc uu____415
let dump_proofstate:
  FStar_Tactics_Types.proofstate -> Prims.string -> Prims.unit =
  fun ps  ->
    fun msg  ->
      FStar_Options.with_saved_options
        (fun uu____480  ->
           FStar_Options.set_option "print_effect_args"
             (FStar_Options.Bool true);
           FStar_Util.print_generic "proof-state" ps_to_string ps_to_json
             (msg, ps))
let print_proof_state1: Prims.string -> Prims.unit tac =
  fun msg  ->
    mk_tac (fun p  -> dump_cur p msg; FStar_Tactics_Result.Success ((), p))
let print_proof_state: Prims.string -> Prims.unit tac =
  fun msg  ->
    mk_tac
      (fun p  -> dump_proofstate p msg; FStar_Tactics_Result.Success ((), p))
let get: FStar_Tactics_Types.proofstate tac =
  mk_tac (fun p  -> FStar_Tactics_Result.Success (p, p))
let tac_verb_dbg: Prims.bool FStar_Pervasives_Native.option FStar_ST.ref =
  FStar_Util.mk_ref FStar_Pervasives_Native.None
let rec log:
  FStar_Tactics_Types.proofstate -> (Prims.unit -> Prims.unit) -> Prims.unit
  =
  fun ps  ->
    fun f  ->
      let uu____540 = FStar_ST.op_Bang tac_verb_dbg in
      match uu____540 with
      | FStar_Pervasives_Native.None  ->
          ((let uu____594 =
              let uu____597 =
                FStar_TypeChecker_Env.debug
                  ps.FStar_Tactics_Types.main_context
                  (FStar_Options.Other "TacVerbose") in
              FStar_Pervasives_Native.Some uu____597 in
            FStar_ST.op_Colon_Equals tac_verb_dbg uu____594);
           log ps f)
      | FStar_Pervasives_Native.Some (true ) -> f ()
      | FStar_Pervasives_Native.Some (false ) -> ()
let mlog: 'a . (Prims.unit -> Prims.unit) -> (Prims.unit -> 'a tac) -> 'a tac
  = fun f  -> fun cont  -> bind get (fun ps  -> log ps f; cont ())
let fail: 'Auu____687 . Prims.string -> 'Auu____687 tac =
  fun msg  ->
    mk_tac
      (fun ps  ->
         (let uu____698 =
            FStar_TypeChecker_Env.debug ps.FStar_Tactics_Types.main_context
              (FStar_Options.Other "TacFail") in
          if uu____698
          then dump_proofstate ps (Prims.strcat "TACTING FAILING: " msg)
          else ());
         FStar_Tactics_Result.Failed (msg, ps))
let fail1: 'Auu____706 . Prims.string -> Prims.string -> 'Auu____706 tac =
  fun msg  ->
    fun x  -> let uu____717 = FStar_Util.format1 msg x in fail uu____717
let fail2:
  'Auu____726 .
    Prims.string -> Prims.string -> Prims.string -> 'Auu____726 tac
  =
  fun msg  ->
    fun x  ->
      fun y  -> let uu____741 = FStar_Util.format2 msg x y in fail uu____741
let fail3:
  'Auu____752 .
    Prims.string ->
      Prims.string -> Prims.string -> Prims.string -> 'Auu____752 tac
  =
  fun msg  ->
    fun x  ->
      fun y  ->
        fun z  ->
          let uu____771 = FStar_Util.format3 msg x y z in fail uu____771
let trytac: 'a . 'a tac -> 'a FStar_Pervasives_Native.option tac =
  fun t  ->
    mk_tac
      (fun ps  ->
         let tx = FStar_Syntax_Unionfind.new_transaction () in
         let uu____799 = run t ps in
         match uu____799 with
         | FStar_Tactics_Result.Success (a,q) ->
             (FStar_Syntax_Unionfind.commit tx;
              FStar_Tactics_Result.Success
                ((FStar_Pervasives_Native.Some a), q))
         | FStar_Tactics_Result.Failed (uu____813,uu____814) ->
             (FStar_Syntax_Unionfind.rollback tx;
              FStar_Tactics_Result.Success (FStar_Pervasives_Native.None, ps)))
let wrap_err: 'a . Prims.string -> 'a tac -> 'a tac =
  fun pref  ->
    fun t  ->
      mk_tac
        (fun ps  ->
           let uu____846 = run t ps in
           match uu____846 with
           | FStar_Tactics_Result.Success (a,q) ->
               FStar_Tactics_Result.Success (a, q)
           | FStar_Tactics_Result.Failed (msg,q) ->
               FStar_Tactics_Result.Failed
                 ((Prims.strcat pref (Prims.strcat ": " msg)), q))
let set: FStar_Tactics_Types.proofstate -> Prims.unit tac =
  fun p  -> mk_tac (fun uu____864  -> FStar_Tactics_Result.Success ((), p))
let do_unify:
  env -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun env  ->
    fun t1  ->
      fun t2  ->
        try FStar_TypeChecker_Rel.teq_nosmt env t1 t2
        with | uu____882 -> false
let trysolve:
  FStar_Tactics_Types.goal -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun goal  ->
    fun solution  ->
      do_unify goal.FStar_Tactics_Types.context solution
        goal.FStar_Tactics_Types.witness
let dismiss: Prims.unit tac =
  bind get
    (fun p  ->
       let uu____896 =
         let uu___124_897 = p in
         let uu____898 = FStar_List.tl p.FStar_Tactics_Types.goals in
         {
           FStar_Tactics_Types.main_context =
             (uu___124_897.FStar_Tactics_Types.main_context);
           FStar_Tactics_Types.main_goal =
             (uu___124_897.FStar_Tactics_Types.main_goal);
           FStar_Tactics_Types.all_implicits =
             (uu___124_897.FStar_Tactics_Types.all_implicits);
           FStar_Tactics_Types.goals = uu____898;
           FStar_Tactics_Types.smt_goals =
             (uu___124_897.FStar_Tactics_Types.smt_goals);
           FStar_Tactics_Types.depth =
             (uu___124_897.FStar_Tactics_Types.depth);
           FStar_Tactics_Types.__dump =
             (uu___124_897.FStar_Tactics_Types.__dump)
         } in
       set uu____896)
let solve:
  FStar_Tactics_Types.goal -> FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun goal  ->
    fun solution  ->
      let uu____913 = trysolve goal solution in
      if uu____913
      then dismiss
      else
        (let uu____917 =
           let uu____918 =
             FStar_TypeChecker_Normalize.term_to_string
               goal.FStar_Tactics_Types.context solution in
           let uu____919 =
             FStar_TypeChecker_Normalize.term_to_string
               goal.FStar_Tactics_Types.context
               goal.FStar_Tactics_Types.witness in
           let uu____920 =
             FStar_TypeChecker_Normalize.term_to_string
               goal.FStar_Tactics_Types.context
               goal.FStar_Tactics_Types.goal_ty in
           FStar_Util.format3 "%s does not solve %s : %s" uu____918 uu____919
             uu____920 in
         fail uu____917)
let dismiss_all: Prims.unit tac =
  bind get
    (fun p  ->
       set
         (let uu___125_927 = p in
          {
            FStar_Tactics_Types.main_context =
              (uu___125_927.FStar_Tactics_Types.main_context);
            FStar_Tactics_Types.main_goal =
              (uu___125_927.FStar_Tactics_Types.main_goal);
            FStar_Tactics_Types.all_implicits =
              (uu___125_927.FStar_Tactics_Types.all_implicits);
            FStar_Tactics_Types.goals = [];
            FStar_Tactics_Types.smt_goals =
              (uu___125_927.FStar_Tactics_Types.smt_goals);
            FStar_Tactics_Types.depth =
              (uu___125_927.FStar_Tactics_Types.depth);
            FStar_Tactics_Types.__dump =
              (uu___125_927.FStar_Tactics_Types.__dump)
          }))
let add_goals: FStar_Tactics_Types.goal Prims.list -> Prims.unit tac =
  fun gs  ->
    bind get
      (fun p  ->
         set
           (let uu___126_944 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___126_944.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___126_944.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (uu___126_944.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (FStar_List.append gs p.FStar_Tactics_Types.goals);
              FStar_Tactics_Types.smt_goals =
                (uu___126_944.FStar_Tactics_Types.smt_goals);
              FStar_Tactics_Types.depth =
                (uu___126_944.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___126_944.FStar_Tactics_Types.__dump)
            }))
let add_smt_goals: FStar_Tactics_Types.goal Prims.list -> Prims.unit tac =
  fun gs  ->
    bind get
      (fun p  ->
         set
           (let uu___127_961 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___127_961.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___127_961.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (uu___127_961.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (uu___127_961.FStar_Tactics_Types.goals);
              FStar_Tactics_Types.smt_goals =
                (FStar_List.append gs p.FStar_Tactics_Types.smt_goals);
              FStar_Tactics_Types.depth =
                (uu___127_961.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___127_961.FStar_Tactics_Types.__dump)
            }))
let push_goals: FStar_Tactics_Types.goal Prims.list -> Prims.unit tac =
  fun gs  ->
    bind get
      (fun p  ->
         set
           (let uu___128_978 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___128_978.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___128_978.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (uu___128_978.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (FStar_List.append p.FStar_Tactics_Types.goals gs);
              FStar_Tactics_Types.smt_goals =
                (uu___128_978.FStar_Tactics_Types.smt_goals);
              FStar_Tactics_Types.depth =
                (uu___128_978.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___128_978.FStar_Tactics_Types.__dump)
            }))
let push_smt_goals: FStar_Tactics_Types.goal Prims.list -> Prims.unit tac =
  fun gs  ->
    bind get
      (fun p  ->
         set
           (let uu___129_995 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___129_995.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___129_995.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (uu___129_995.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (uu___129_995.FStar_Tactics_Types.goals);
              FStar_Tactics_Types.smt_goals =
                (FStar_List.append p.FStar_Tactics_Types.smt_goals gs);
              FStar_Tactics_Types.depth =
                (uu___129_995.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___129_995.FStar_Tactics_Types.__dump)
            }))
let replace_cur: FStar_Tactics_Types.goal -> Prims.unit tac =
  fun g  -> bind dismiss (fun uu____1005  -> add_goals [g])
let add_implicits: implicits -> Prims.unit tac =
  fun i  ->
    bind get
      (fun p  ->
         set
           (let uu___130_1018 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___130_1018.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___130_1018.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (FStar_List.append i p.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (uu___130_1018.FStar_Tactics_Types.goals);
              FStar_Tactics_Types.smt_goals =
                (uu___130_1018.FStar_Tactics_Types.smt_goals);
              FStar_Tactics_Types.depth =
                (uu___130_1018.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___130_1018.FStar_Tactics_Types.__dump)
            }))
let new_uvar:
  Prims.string ->
    env -> FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.term tac
  =
  fun reason  ->
    fun env  ->
      fun typ  ->
        let uu____1047 =
          FStar_TypeChecker_Util.new_implicit_var reason
            typ.FStar_Syntax_Syntax.pos env typ in
        match uu____1047 with
        | (u,uu____1063,g_u) ->
            let uu____1077 =
              add_implicits g_u.FStar_TypeChecker_Env.implicits in
            bind uu____1077 (fun uu____1081  -> ret u)
let is_true: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____1086 = FStar_Syntax_Util.un_squash t in
    match uu____1086 with
    | FStar_Pervasives_Native.Some t' ->
        let uu____1096 =
          let uu____1097 = FStar_Syntax_Subst.compress t' in
          uu____1097.FStar_Syntax_Syntax.n in
        (match uu____1096 with
         | FStar_Syntax_Syntax.Tm_fvar fv ->
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.true_lid
         | uu____1101 -> false)
    | uu____1102 -> false
let is_false: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____1111 = FStar_Syntax_Util.un_squash t in
    match uu____1111 with
    | FStar_Pervasives_Native.Some t' ->
        let uu____1121 =
          let uu____1122 = FStar_Syntax_Subst.compress t' in
          uu____1122.FStar_Syntax_Syntax.n in
        (match uu____1121 with
         | FStar_Syntax_Syntax.Tm_fvar fv ->
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.false_lid
         | uu____1126 -> false)
    | uu____1127 -> false
let cur_goal: FStar_Tactics_Types.goal tac =
  bind get
    (fun p  ->
       match p.FStar_Tactics_Types.goals with
       | [] -> fail "No more goals (1)"
       | hd1::tl1 -> ret hd1)
let mk_irrelevant_goal:
  Prims.string ->
    env ->
      FStar_Syntax_Syntax.typ ->
        FStar_Options.optionstate -> FStar_Tactics_Types.goal tac
  =
  fun reason  ->
    fun env  ->
      fun phi  ->
        fun opts  ->
          let typ = FStar_Syntax_Util.mk_squash phi in
          let uu____1165 = new_uvar reason env typ in
          bind uu____1165
            (fun u  ->
               let goal =
                 {
                   FStar_Tactics_Types.context = env;
                   FStar_Tactics_Types.witness = u;
                   FStar_Tactics_Types.goal_ty = typ;
                   FStar_Tactics_Types.opts = opts;
                   FStar_Tactics_Types.is_guard = false
                 } in
               ret goal)
let __tc:
  env ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.typ,FStar_TypeChecker_Env.guard_t)
        FStar_Pervasives_Native.tuple3 tac
  =
  fun e  ->
    fun t  ->
      bind get
        (fun ps  ->
           try
             let uu____1223 =
               (ps.FStar_Tactics_Types.main_context).FStar_TypeChecker_Env.type_of
                 e t in
             ret uu____1223
           with | e1 -> fail "not typeable")
let tc: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.typ tac =
  fun t  ->
    let uu____1262 =
      bind cur_goal
        (fun goal  ->
           let uu____1268 = __tc goal.FStar_Tactics_Types.context t in
           bind uu____1268
             (fun uu____1288  ->
                match uu____1288 with
                | (t1,typ,guard) ->
                    let uu____1300 =
                      let uu____1301 =
                        let uu____1302 =
                          FStar_TypeChecker_Rel.discharge_guard
                            goal.FStar_Tactics_Types.context guard in
                        FStar_All.pipe_left FStar_TypeChecker_Rel.is_trivial
                          uu____1302 in
                      Prims.op_Negation uu____1301 in
                    if uu____1300
                    then fail "got non-trivial guard"
                    else ret typ)) in
    FStar_All.pipe_left (wrap_err "tc") uu____1262
let add_irrelevant_goal:
  Prims.string ->
    env ->
      FStar_Syntax_Syntax.typ -> FStar_Options.optionstate -> Prims.unit tac
  =
  fun reason  ->
    fun env  ->
      fun phi  ->
        fun opts  ->
          let uu____1330 = mk_irrelevant_goal reason env phi opts in
          bind uu____1330 (fun goal  -> add_goals [goal])
let istrivial: env -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun e  ->
    fun t  ->
      let steps =
        [FStar_TypeChecker_Normalize.Reify;
        FStar_TypeChecker_Normalize.UnfoldUntil
          FStar_Syntax_Syntax.Delta_constant;
        FStar_TypeChecker_Normalize.Primops;
        FStar_TypeChecker_Normalize.Simplify;
        FStar_TypeChecker_Normalize.UnfoldTac;
        FStar_TypeChecker_Normalize.Unmeta] in
      let t1 = normalize steps e t in is_true t1
let trivial: Prims.unit tac =
  bind cur_goal
    (fun goal  ->
       let uu____1352 =
         istrivial goal.FStar_Tactics_Types.context
           goal.FStar_Tactics_Types.goal_ty in
       if uu____1352
       then solve goal FStar_Syntax_Util.exp_unit
       else
         (let uu____1356 =
            FStar_TypeChecker_Normalize.term_to_string
              goal.FStar_Tactics_Types.context
              goal.FStar_Tactics_Types.goal_ty in
          fail1 "Not a trivial goal: %s" uu____1356))
let add_goal_from_guard:
  Prims.string ->
    env ->
      FStar_TypeChecker_Env.guard_t ->
        FStar_Options.optionstate -> Prims.unit tac
  =
  fun reason  ->
    fun e  ->
      fun g  ->
        fun opts  ->
          let uu____1377 =
            let uu____1378 = FStar_TypeChecker_Rel.simplify_guard e g in
            uu____1378.FStar_TypeChecker_Env.guard_f in
          match uu____1377 with
          | FStar_TypeChecker_Common.Trivial  -> ret ()
          | FStar_TypeChecker_Common.NonTrivial f ->
              let uu____1382 = istrivial e f in
              if uu____1382
              then ret ()
              else
                (let uu____1386 = mk_irrelevant_goal reason e f opts in
                 bind uu____1386
                   (fun goal  ->
                      let goal1 =
                        let uu___133_1393 = goal in
                        {
                          FStar_Tactics_Types.context =
                            (uu___133_1393.FStar_Tactics_Types.context);
                          FStar_Tactics_Types.witness =
                            (uu___133_1393.FStar_Tactics_Types.witness);
                          FStar_Tactics_Types.goal_ty =
                            (uu___133_1393.FStar_Tactics_Types.goal_ty);
                          FStar_Tactics_Types.opts =
                            (uu___133_1393.FStar_Tactics_Types.opts);
                          FStar_Tactics_Types.is_guard = true
                        } in
                      push_goals [goal1]))
let smt: Prims.unit tac =
  bind cur_goal
    (fun g  ->
       let uu____1399 = is_irrelevant g in
       if uu____1399
       then bind dismiss (fun uu____1403  -> add_smt_goals [g])
       else
         (let uu____1405 =
            FStar_TypeChecker_Normalize.term_to_string
              g.FStar_Tactics_Types.context g.FStar_Tactics_Types.goal_ty in
          fail1 "goal is not irrelevant: cannot dispatch to smt (%s)"
            uu____1405))
let divide:
  'a 'b .
    Prims.int ->
      'a tac -> 'b tac -> ('a,'b) FStar_Pervasives_Native.tuple2 tac
  =
  fun n1  ->
    fun l  ->
      fun r  ->
        bind get
          (fun p  ->
             let uu____1451 =
               try
                 let uu____1485 =
                   FStar_List.splitAt n1 p.FStar_Tactics_Types.goals in
                 ret uu____1485
               with | uu____1515 -> fail "divide: not enough goals" in
             bind uu____1451
               (fun uu____1542  ->
                  match uu____1542 with
                  | (lgs,rgs) ->
                      let lp =
                        let uu___134_1568 = p in
                        {
                          FStar_Tactics_Types.main_context =
                            (uu___134_1568.FStar_Tactics_Types.main_context);
                          FStar_Tactics_Types.main_goal =
                            (uu___134_1568.FStar_Tactics_Types.main_goal);
                          FStar_Tactics_Types.all_implicits =
                            (uu___134_1568.FStar_Tactics_Types.all_implicits);
                          FStar_Tactics_Types.goals = lgs;
                          FStar_Tactics_Types.smt_goals = [];
                          FStar_Tactics_Types.depth =
                            (uu___134_1568.FStar_Tactics_Types.depth);
                          FStar_Tactics_Types.__dump =
                            (uu___134_1568.FStar_Tactics_Types.__dump)
                        } in
                      let rp =
                        let uu___135_1570 = p in
                        {
                          FStar_Tactics_Types.main_context =
                            (uu___135_1570.FStar_Tactics_Types.main_context);
                          FStar_Tactics_Types.main_goal =
                            (uu___135_1570.FStar_Tactics_Types.main_goal);
                          FStar_Tactics_Types.all_implicits =
                            (uu___135_1570.FStar_Tactics_Types.all_implicits);
                          FStar_Tactics_Types.goals = rgs;
                          FStar_Tactics_Types.smt_goals = [];
                          FStar_Tactics_Types.depth =
                            (uu___135_1570.FStar_Tactics_Types.depth);
                          FStar_Tactics_Types.__dump =
                            (uu___135_1570.FStar_Tactics_Types.__dump)
                        } in
                      let uu____1571 = set lp in
                      bind uu____1571
                        (fun uu____1579  ->
                           bind l
                             (fun a  ->
                                bind get
                                  (fun lp'  ->
                                     let uu____1593 = set rp in
                                     bind uu____1593
                                       (fun uu____1601  ->
                                          bind r
                                            (fun b  ->
                                               bind get
                                                 (fun rp'  ->
                                                    let p' =
                                                      let uu___136_1617 = p in
                                                      {
                                                        FStar_Tactics_Types.main_context
                                                          =
                                                          (uu___136_1617.FStar_Tactics_Types.main_context);
                                                        FStar_Tactics_Types.main_goal
                                                          =
                                                          (uu___136_1617.FStar_Tactics_Types.main_goal);
                                                        FStar_Tactics_Types.all_implicits
                                                          =
                                                          (uu___136_1617.FStar_Tactics_Types.all_implicits);
                                                        FStar_Tactics_Types.goals
                                                          =
                                                          (FStar_List.append
                                                             lp'.FStar_Tactics_Types.goals
                                                             rp'.FStar_Tactics_Types.goals);
                                                        FStar_Tactics_Types.smt_goals
                                                          =
                                                          (FStar_List.append
                                                             lp'.FStar_Tactics_Types.smt_goals
                                                             (FStar_List.append
                                                                rp'.FStar_Tactics_Types.smt_goals
                                                                p.FStar_Tactics_Types.smt_goals));
                                                        FStar_Tactics_Types.depth
                                                          =
                                                          (uu___136_1617.FStar_Tactics_Types.depth);
                                                        FStar_Tactics_Types.__dump
                                                          =
                                                          (uu___136_1617.FStar_Tactics_Types.__dump)
                                                      } in
                                                    let uu____1618 = set p' in
                                                    bind uu____1618
                                                      (fun uu____1626  ->
                                                         ret (a, b))))))))))
let focus: 'a . 'a tac -> 'a tac =
  fun f  ->
    let uu____1646 = divide (Prims.parse_int "1") f idtac in
    bind uu____1646
      (fun uu____1659  -> match uu____1659 with | (a,()) -> ret a)
let rec map: 'a . 'a tac -> 'a Prims.list tac =
  fun tau  ->
    bind get
      (fun p  ->
         match p.FStar_Tactics_Types.goals with
         | [] -> ret []
         | uu____1694::uu____1695 ->
             let uu____1698 =
               let uu____1707 = map tau in
               divide (Prims.parse_int "1") tau uu____1707 in
             bind uu____1698
               (fun uu____1725  ->
                  match uu____1725 with | (h,t) -> ret (h :: t)))
let seq: Prims.unit tac -> Prims.unit tac -> Prims.unit tac =
  fun t1  ->
    fun t2  ->
      let uu____1764 =
        bind t1
          (fun uu____1769  ->
             let uu____1770 = map t2 in
             bind uu____1770 (fun uu____1778  -> ret ())) in
      focus uu____1764
let intro: FStar_Syntax_Syntax.binder tac =
  bind cur_goal
    (fun goal  ->
       let uu____1789 =
         FStar_Syntax_Util.arrow_one goal.FStar_Tactics_Types.goal_ty in
       match uu____1789 with
       | FStar_Pervasives_Native.Some (b,c) ->
           let uu____1804 =
             let uu____1805 = FStar_Syntax_Util.is_total_comp c in
             Prims.op_Negation uu____1805 in
           if uu____1804
           then fail "Codomain is effectful"
           else
             (let env' =
                FStar_TypeChecker_Env.push_binders
                  goal.FStar_Tactics_Types.context [b] in
              let typ' = comp_to_typ c in
              let uu____1811 = new_uvar "intro" env' typ' in
              bind uu____1811
                (fun u  ->
                   let uu____1818 =
                     let uu____1819 =
                       FStar_Syntax_Util.abs [b] u
                         FStar_Pervasives_Native.None in
                     trysolve goal uu____1819 in
                   if uu____1818
                   then
                     let uu____1822 =
                       let uu____1825 =
                         let uu___139_1826 = goal in
                         let uu____1827 = bnorm env' u in
                         let uu____1828 = bnorm env' typ' in
                         {
                           FStar_Tactics_Types.context = env';
                           FStar_Tactics_Types.witness = uu____1827;
                           FStar_Tactics_Types.goal_ty = uu____1828;
                           FStar_Tactics_Types.opts =
                             (uu___139_1826.FStar_Tactics_Types.opts);
                           FStar_Tactics_Types.is_guard =
                             (uu___139_1826.FStar_Tactics_Types.is_guard)
                         } in
                       replace_cur uu____1825 in
                     bind uu____1822 (fun uu____1830  -> ret b)
                   else fail "intro: unification failed"))
       | FStar_Pervasives_Native.None  ->
           let uu____1836 =
             FStar_TypeChecker_Normalize.term_to_string
               goal.FStar_Tactics_Types.context
               goal.FStar_Tactics_Types.goal_ty in
           fail1 "intro: goal is not an arrow (%s)" uu____1836)
let intro_rec:
  (FStar_Syntax_Syntax.binder,FStar_Syntax_Syntax.binder)
    FStar_Pervasives_Native.tuple2 tac
  =
  bind cur_goal
    (fun goal  ->
       FStar_Util.print_string
         "WARNING (intro_rec): calling this is known to cause normalizer loops\n";
       FStar_Util.print_string
         "WARNING (intro_rec): proceed at your own risk...\n";
       (let uu____1857 =
          FStar_Syntax_Util.arrow_one goal.FStar_Tactics_Types.goal_ty in
        match uu____1857 with
        | FStar_Pervasives_Native.Some (b,c) ->
            let uu____1876 =
              let uu____1877 = FStar_Syntax_Util.is_total_comp c in
              Prims.op_Negation uu____1877 in
            if uu____1876
            then fail "Codomain is effectful"
            else
              (let bv =
                 FStar_Syntax_Syntax.gen_bv "__recf"
                   FStar_Pervasives_Native.None
                   goal.FStar_Tactics_Types.goal_ty in
               let bs =
                 let uu____1893 = FStar_Syntax_Syntax.mk_binder bv in
                 [uu____1893; b] in
               let env' =
                 FStar_TypeChecker_Env.push_binders
                   goal.FStar_Tactics_Types.context bs in
               let uu____1895 =
                 let uu____1898 = comp_to_typ c in
                 new_uvar "intro_rec" env' uu____1898 in
               bind uu____1895
                 (fun u  ->
                    let lb =
                      let uu____1914 =
                        FStar_Syntax_Util.abs [b] u
                          FStar_Pervasives_Native.None in
                      FStar_Syntax_Util.mk_letbinding (FStar_Util.Inl bv) []
                        goal.FStar_Tactics_Types.goal_ty
                        FStar_Parser_Const.effect_Tot_lid uu____1914 in
                    let body = FStar_Syntax_Syntax.bv_to_name bv in
                    let uu____1918 =
                      FStar_Syntax_Subst.close_let_rec [lb] body in
                    match uu____1918 with
                    | (lbs,body1) ->
                        let tm =
                          FStar_Syntax_Syntax.mk
                            (FStar_Syntax_Syntax.Tm_let ((true, lbs), body1))
                            FStar_Pervasives_Native.None
                            (goal.FStar_Tactics_Types.witness).FStar_Syntax_Syntax.pos in
                        let res = trysolve goal tm in
                        if res
                        then
                          let uu____1955 =
                            let uu____1958 =
                              let uu___140_1959 = goal in
                              let uu____1960 = bnorm env' u in
                              let uu____1961 =
                                let uu____1962 = comp_to_typ c in
                                bnorm env' uu____1962 in
                              {
                                FStar_Tactics_Types.context = env';
                                FStar_Tactics_Types.witness = uu____1960;
                                FStar_Tactics_Types.goal_ty = uu____1961;
                                FStar_Tactics_Types.opts =
                                  (uu___140_1959.FStar_Tactics_Types.opts);
                                FStar_Tactics_Types.is_guard =
                                  (uu___140_1959.FStar_Tactics_Types.is_guard)
                              } in
                            replace_cur uu____1958 in
                          bind uu____1955
                            (fun uu____1969  ->
                               let uu____1970 =
                                 let uu____1975 =
                                   FStar_Syntax_Syntax.mk_binder bv in
                                 (uu____1975, b) in
                               ret uu____1970)
                        else fail "intro_rec: unification failed"))
        | FStar_Pervasives_Native.None  ->
            let uu____1989 =
              FStar_TypeChecker_Normalize.term_to_string
                goal.FStar_Tactics_Types.context
                goal.FStar_Tactics_Types.goal_ty in
            fail1 "intro_rec: goal is not an arrow (%s)" uu____1989))
let norm: FStar_Syntax_Embeddings.norm_step Prims.list -> Prims.unit tac =
  fun s  ->
    bind cur_goal
      (fun goal  ->
         let steps =
           let uu____2014 = FStar_TypeChecker_Normalize.tr_norm_steps s in
           FStar_List.append
             [FStar_TypeChecker_Normalize.Reify;
             FStar_TypeChecker_Normalize.UnfoldTac] uu____2014 in
         let w =
           normalize steps goal.FStar_Tactics_Types.context
             goal.FStar_Tactics_Types.witness in
         let t =
           normalize steps goal.FStar_Tactics_Types.context
             goal.FStar_Tactics_Types.goal_ty in
         replace_cur
           (let uu___141_2021 = goal in
            {
              FStar_Tactics_Types.context =
                (uu___141_2021.FStar_Tactics_Types.context);
              FStar_Tactics_Types.witness = w;
              FStar_Tactics_Types.goal_ty = t;
              FStar_Tactics_Types.opts =
                (uu___141_2021.FStar_Tactics_Types.opts);
              FStar_Tactics_Types.is_guard =
                (uu___141_2021.FStar_Tactics_Types.is_guard)
            }))
let norm_term_env:
  env ->
    FStar_Syntax_Embeddings.norm_step Prims.list ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac
  =
  fun e  ->
    fun s  ->
      fun t  ->
        let uu____2042 =
          bind get
            (fun ps  ->
               let uu____2048 = __tc e t in
               bind uu____2048
                 (fun uu____2070  ->
                    match uu____2070 with
                    | (t1,uu____2080,guard) ->
                        (FStar_TypeChecker_Rel.force_trivial_guard e guard;
                         (let steps =
                            let uu____2086 =
                              FStar_TypeChecker_Normalize.tr_norm_steps s in
                            FStar_List.append
                              [FStar_TypeChecker_Normalize.Reify;
                              FStar_TypeChecker_Normalize.UnfoldTac]
                              uu____2086 in
                          let t2 =
                            normalize steps
                              ps.FStar_Tactics_Types.main_context t1 in
                          ret t2)))) in
        FStar_All.pipe_left (wrap_err "norm_term") uu____2042
let __exact: FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun t  ->
    bind cur_goal
      (fun goal  ->
         let uu____2105 = __tc goal.FStar_Tactics_Types.context t in
         bind uu____2105
           (fun uu____2125  ->
              match uu____2125 with
              | (t1,typ,guard) ->
                  let uu____2137 =
                    let uu____2138 =
                      let uu____2139 =
                        FStar_TypeChecker_Rel.discharge_guard
                          goal.FStar_Tactics_Types.context guard in
                      FStar_All.pipe_left FStar_TypeChecker_Rel.is_trivial
                        uu____2139 in
                    Prims.op_Negation uu____2138 in
                  if uu____2137
                  then fail "got non-trivial guard"
                  else
                    (let uu____2143 =
                       do_unify goal.FStar_Tactics_Types.context typ
                         goal.FStar_Tactics_Types.goal_ty in
                     if uu____2143
                     then solve goal t1
                     else
                       (let uu____2147 =
                          FStar_TypeChecker_Normalize.term_to_string
                            goal.FStar_Tactics_Types.context t1 in
                        let uu____2148 =
                          let uu____2149 =
                            bnorm goal.FStar_Tactics_Types.context typ in
                          FStar_TypeChecker_Normalize.term_to_string
                            goal.FStar_Tactics_Types.context uu____2149 in
                        let uu____2150 =
                          FStar_TypeChecker_Normalize.term_to_string
                            goal.FStar_Tactics_Types.context
                            goal.FStar_Tactics_Types.goal_ty in
                        fail3 "%s : %s does not exactly solve the goal %s"
                          uu____2147 uu____2148 uu____2150))))
let exact: FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun tm  ->
    let uu____2159 =
      mlog
        (fun uu____2164  ->
           let uu____2165 = FStar_Syntax_Print.term_to_string tm in
           FStar_Util.print1 "exact: tm = %s\n" uu____2165)
        (fun uu____2168  -> let uu____2169 = __exact tm in focus uu____2169) in
    FStar_All.pipe_left (wrap_err "exact") uu____2159
let uvar_free_in_goal:
  FStar_Syntax_Syntax.uvar -> FStar_Tactics_Types.goal -> Prims.bool =
  fun u  ->
    fun g  ->
      if g.FStar_Tactics_Types.is_guard
      then false
      else
        (let free_uvars =
           let uu____2188 =
             let uu____2195 =
               FStar_Syntax_Free.uvars g.FStar_Tactics_Types.goal_ty in
             FStar_Util.set_elements uu____2195 in
           FStar_List.map FStar_Pervasives_Native.fst uu____2188 in
         FStar_List.existsML (FStar_Syntax_Unionfind.equiv u) free_uvars)
let uvar_free:
  FStar_Syntax_Syntax.uvar -> FStar_Tactics_Types.proofstate -> Prims.bool =
  fun u  ->
    fun ps  ->
      FStar_List.existsML (uvar_free_in_goal u) ps.FStar_Tactics_Types.goals
exception NoUnif
let uu___is_NoUnif: Prims.exn -> Prims.bool =
  fun projectee  ->
    match projectee with | NoUnif  -> true | uu____2222 -> false
let rec __apply:
  Prims.bool ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.typ -> Prims.unit tac
  =
  fun uopt  ->
    fun tm  ->
      fun typ  ->
        bind cur_goal
          (fun goal  ->
             let uu____2242 =
               let uu____2247 = __exact tm in trytac uu____2247 in
             bind uu____2242
               (fun r  ->
                  match r with
                  | FStar_Pervasives_Native.Some r1 -> ret ()
                  | FStar_Pervasives_Native.None  ->
                      let uu____2260 = FStar_Syntax_Util.arrow_one typ in
                      (match uu____2260 with
                       | FStar_Pervasives_Native.None  ->
                           FStar_Exn.raise NoUnif
                       | FStar_Pervasives_Native.Some ((bv,aq),c) ->
                           mlog
                             (fun uu____2292  ->
                                let uu____2293 =
                                  FStar_Syntax_Print.binder_to_string
                                    (bv, aq) in
                                FStar_Util.print1
                                  "__apply: pushing binder %s\n" uu____2293)
                             (fun uu____2296  ->
                                let uu____2297 =
                                  let uu____2298 =
                                    FStar_Syntax_Util.is_total_comp c in
                                  Prims.op_Negation uu____2298 in
                                if uu____2297
                                then fail "apply: not total codomain"
                                else
                                  (let uu____2302 =
                                     new_uvar "apply"
                                       goal.FStar_Tactics_Types.context
                                       bv.FStar_Syntax_Syntax.sort in
                                   bind uu____2302
                                     (fun u  ->
                                        let tm' =
                                          FStar_Syntax_Syntax.mk_Tm_app tm
                                            [(u, aq)]
                                            FStar_Pervasives_Native.None
                                            (goal.FStar_Tactics_Types.context).FStar_TypeChecker_Env.range in
                                        let typ' =
                                          let uu____2322 = comp_to_typ c in
                                          FStar_All.pipe_left
                                            (FStar_Syntax_Subst.subst
                                               [FStar_Syntax_Syntax.NT
                                                  (bv, u)]) uu____2322 in
                                        let uu____2323 =
                                          __apply uopt tm' typ' in
                                        bind uu____2323
                                          (fun uu____2331  ->
                                             let u1 =
                                               bnorm
                                                 goal.FStar_Tactics_Types.context
                                                 u in
                                             let uu____2333 =
                                               let uu____2334 =
                                                 let uu____2337 =
                                                   let uu____2338 =
                                                     FStar_Syntax_Util.head_and_args
                                                       u1 in
                                                   FStar_Pervasives_Native.fst
                                                     uu____2338 in
                                                 FStar_Syntax_Subst.compress
                                                   uu____2337 in
                                               uu____2334.FStar_Syntax_Syntax.n in
                                             match uu____2333 with
                                             | FStar_Syntax_Syntax.Tm_uvar
                                                 (uvar,uu____2366) ->
                                                 bind get
                                                   (fun ps  ->
                                                      let uu____2394 =
                                                        uopt &&
                                                          (uvar_free uvar ps) in
                                                      if uu____2394
                                                      then ret ()
                                                      else
                                                        (let uu____2398 =
                                                           let uu____2401 =
                                                             let uu___142_2402
                                                               = goal in
                                                             let uu____2403 =
                                                               bnorm
                                                                 goal.FStar_Tactics_Types.context
                                                                 u1 in
                                                             let uu____2404 =
                                                               bnorm
                                                                 goal.FStar_Tactics_Types.context
                                                                 bv.FStar_Syntax_Syntax.sort in
                                                             {
                                                               FStar_Tactics_Types.context
                                                                 =
                                                                 (uu___142_2402.FStar_Tactics_Types.context);
                                                               FStar_Tactics_Types.witness
                                                                 = uu____2403;
                                                               FStar_Tactics_Types.goal_ty
                                                                 = uu____2404;
                                                               FStar_Tactics_Types.opts
                                                                 =
                                                                 (uu___142_2402.FStar_Tactics_Types.opts);
                                                               FStar_Tactics_Types.is_guard
                                                                 = false
                                                             } in
                                                           [uu____2401] in
                                                         add_goals uu____2398))
                                             | t -> ret ())))))))
let try_unif: 'a . 'a tac -> 'a tac -> 'a tac =
  fun t  ->
    fun t'  -> mk_tac (fun ps  -> try run t ps with | NoUnif  -> run t' ps)
let apply: Prims.bool -> FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun uopt  ->
    fun tm  ->
      let uu____2455 =
        mlog
          (fun uu____2460  ->
             let uu____2461 = FStar_Syntax_Print.term_to_string tm in
             FStar_Util.print1 "apply: tm = %s\n" uu____2461)
          (fun uu____2463  ->
             bind cur_goal
               (fun goal  ->
                  let uu____2467 = __tc goal.FStar_Tactics_Types.context tm in
                  bind uu____2467
                    (fun uu____2488  ->
                       match uu____2488 with
                       | (tm1,typ,guard) ->
                           let uu____2500 =
                             let uu____2503 =
                               let uu____2506 = __apply uopt tm1 typ in
                               bind uu____2506
                                 (fun uu____2510  ->
                                    add_goal_from_guard "apply guard"
                                      goal.FStar_Tactics_Types.context guard
                                      goal.FStar_Tactics_Types.opts) in
                             focus uu____2503 in
                           let uu____2511 =
                             let uu____2514 =
                               FStar_TypeChecker_Normalize.term_to_string
                                 goal.FStar_Tactics_Types.context tm1 in
                             let uu____2515 =
                               FStar_TypeChecker_Normalize.term_to_string
                                 goal.FStar_Tactics_Types.context typ in
                             let uu____2516 =
                               FStar_TypeChecker_Normalize.term_to_string
                                 goal.FStar_Tactics_Types.context
                                 goal.FStar_Tactics_Types.goal_ty in
                             fail3
                               "Cannot instantiate %s (of type %s) to match goal (%s)"
                               uu____2514 uu____2515 uu____2516 in
                           try_unif uu____2500 uu____2511))) in
      FStar_All.pipe_left (wrap_err "apply") uu____2455
let apply_lemma: FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun tm  ->
    let uu____2529 =
      let uu____2532 =
        mlog
          (fun uu____2537  ->
             let uu____2538 = FStar_Syntax_Print.term_to_string tm in
             FStar_Util.print1 "apply_lemma: tm = %s\n" uu____2538)
          (fun uu____2541  ->
             let is_unit_t t =
               let uu____2546 =
                 let uu____2547 = FStar_Syntax_Subst.compress t in
                 uu____2547.FStar_Syntax_Syntax.n in
               match uu____2546 with
               | FStar_Syntax_Syntax.Tm_fvar fv when
                   FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.unit_lid
                   -> true
               | uu____2551 -> false in
             bind cur_goal
               (fun goal  ->
                  let uu____2555 = __tc goal.FStar_Tactics_Types.context tm in
                  bind uu____2555
                    (fun uu____2577  ->
                       match uu____2577 with
                       | (tm1,t,guard) ->
                           let uu____2589 =
                             FStar_Syntax_Util.arrow_formals_comp t in
                           (match uu____2589 with
                            | (bs,comp) ->
                                if
                                  Prims.op_Negation
                                    (FStar_Syntax_Util.is_lemma_comp comp)
                                then fail "not a lemma"
                                else
                                  (let uu____2619 =
                                     FStar_List.fold_left
                                       (fun uu____2665  ->
                                          fun uu____2666  ->
                                            match (uu____2665, uu____2666)
                                            with
                                            | ((uvs,guard1,subst1),(b,aq)) ->
                                                let b_t =
                                                  FStar_Syntax_Subst.subst
                                                    subst1
                                                    b.FStar_Syntax_Syntax.sort in
                                                let uu____2769 =
                                                  is_unit_t b_t in
                                                if uu____2769
                                                then
                                                  (((FStar_Syntax_Util.exp_unit,
                                                      aq) :: uvs), guard1,
                                                    ((FStar_Syntax_Syntax.NT
                                                        (b,
                                                          FStar_Syntax_Util.exp_unit))
                                                    :: subst1))
                                                else
                                                  (let uu____2807 =
                                                     FStar_TypeChecker_Util.new_implicit_var
                                                       "apply_lemma"
                                                       (goal.FStar_Tactics_Types.goal_ty).FStar_Syntax_Syntax.pos
                                                       goal.FStar_Tactics_Types.context
                                                       b_t in
                                                   match uu____2807 with
                                                   | (u,uu____2837,g_u) ->
                                                       let uu____2851 =
                                                         FStar_TypeChecker_Rel.conj_guard
                                                           guard1 g_u in
                                                       (((u, aq) :: uvs),
                                                         uu____2851,
                                                         ((FStar_Syntax_Syntax.NT
                                                             (b, u)) ::
                                                         subst1))))
                                       ([], guard, []) bs in
                                   match uu____2619 with
                                   | (uvs,implicits,subst1) ->
                                       let uvs1 = FStar_List.rev uvs in
                                       let comp1 =
                                         FStar_Syntax_Subst.subst_comp subst1
                                           comp in
                                       let uu____2921 =
                                         let uu____2930 =
                                           let uu____2939 =
                                             FStar_Syntax_Util.comp_to_comp_typ
                                               comp1 in
                                           uu____2939.FStar_Syntax_Syntax.effect_args in
                                         match uu____2930 with
                                         | pre::post::uu____2950 ->
                                             ((FStar_Pervasives_Native.fst
                                                 pre),
                                               (FStar_Pervasives_Native.fst
                                                  post))
                                         | uu____2991 ->
                                             failwith
                                               "apply_lemma: impossible: not a lemma" in
                                       (match uu____2921 with
                                        | (pre,post) ->
                                            let uu____3020 =
                                              let uu____3021 =
                                                let uu____3022 =
                                                  FStar_Syntax_Util.mk_squash
                                                    post in
                                                do_unify
                                                  goal.FStar_Tactics_Types.context
                                                  uu____3022
                                                  goal.FStar_Tactics_Types.goal_ty in
                                              Prims.op_Negation uu____3021 in
                                            if uu____3020
                                            then
                                              let uu____3025 =
                                                FStar_TypeChecker_Normalize.term_to_string
                                                  goal.FStar_Tactics_Types.context
                                                  tm1 in
                                              let uu____3026 =
                                                let uu____3027 =
                                                  FStar_Syntax_Util.mk_squash
                                                    post in
                                                FStar_TypeChecker_Normalize.term_to_string
                                                  goal.FStar_Tactics_Types.context
                                                  uu____3027 in
                                              let uu____3028 =
                                                FStar_TypeChecker_Normalize.term_to_string
                                                  goal.FStar_Tactics_Types.context
                                                  goal.FStar_Tactics_Types.goal_ty in
                                              fail3
                                                "Cannot instantiate lemma %s (with postcondition: %s) to match goal (%s)"
                                                uu____3025 uu____3026
                                                uu____3028
                                            else
                                              (let solution =
                                                 let uu____3031 =
                                                   FStar_Syntax_Syntax.mk_Tm_app
                                                     tm1 uvs1
                                                     FStar_Pervasives_Native.None
                                                     (goal.FStar_Tactics_Types.context).FStar_TypeChecker_Env.range in
                                                 FStar_TypeChecker_Normalize.normalize
                                                   [FStar_TypeChecker_Normalize.Beta]
                                                   goal.FStar_Tactics_Types.context
                                                   uu____3031 in
                                               let uu____3032 =
                                                 add_implicits
                                                   implicits.FStar_TypeChecker_Env.implicits in
                                               bind uu____3032
                                                 (fun uu____3038  ->
                                                    let implicits1 =
                                                      FStar_All.pipe_right
                                                        implicits.FStar_TypeChecker_Env.implicits
                                                        (FStar_List.filter
                                                           (fun uu____3106 
                                                              ->
                                                              match uu____3106
                                                              with
                                                              | (uu____3119,uu____3120,uu____3121,tm2,uu____3123,uu____3124)
                                                                  ->
                                                                  let uu____3125
                                                                    =
                                                                    FStar_Syntax_Util.head_and_args
                                                                    tm2 in
                                                                  (match uu____3125
                                                                   with
                                                                   | 
                                                                   (hd1,uu____3141)
                                                                    ->
                                                                    let uu____3162
                                                                    =
                                                                    let uu____3163
                                                                    =
                                                                    FStar_Syntax_Subst.compress
                                                                    hd1 in
                                                                    uu____3163.FStar_Syntax_Syntax.n in
                                                                    (match uu____3162
                                                                    with
                                                                    | 
                                                                    FStar_Syntax_Syntax.Tm_uvar
                                                                    uu____3166
                                                                    -> true
                                                                    | 
                                                                    uu____3183
                                                                    -> false)))) in
                                                    let uu____3184 =
                                                      solve goal solution in
                                                    bind uu____3184
                                                      (fun uu____3195  ->
                                                         let is_free_uvar uv
                                                           t1 =
                                                           let free_uvars =
                                                             let uu____3206 =
                                                               let uu____3213
                                                                 =
                                                                 FStar_Syntax_Free.uvars
                                                                   t1 in
                                                               FStar_Util.set_elements
                                                                 uu____3213 in
                                                             FStar_List.map
                                                               FStar_Pervasives_Native.fst
                                                               uu____3206 in
                                                           FStar_List.existsML
                                                             (fun u  ->
                                                                FStar_Syntax_Unionfind.equiv
                                                                  u uv)
                                                             free_uvars in
                                                         let appears uv goals
                                                           =
                                                           FStar_List.existsML
                                                             (fun g'  ->
                                                                is_free_uvar
                                                                  uv
                                                                  g'.FStar_Tactics_Types.goal_ty)
                                                             goals in
                                                         let checkone t1
                                                           goals =
                                                           let uu____3254 =
                                                             FStar_Syntax_Util.head_and_args
                                                               t1 in
                                                           match uu____3254
                                                           with
                                                           | (hd1,uu____3270)
                                                               ->
                                                               (match 
                                                                  hd1.FStar_Syntax_Syntax.n
                                                                with
                                                                | FStar_Syntax_Syntax.Tm_uvar
                                                                    (uv,uu____3292)
                                                                    ->
                                                                    appears
                                                                    uv goals
                                                                | uu____3317
                                                                    -> false) in
                                                         let sub_goals =
                                                           FStar_All.pipe_right
                                                             implicits1
                                                             (FStar_List.map
                                                                (fun
                                                                   uu____3359
                                                                    ->
                                                                   match uu____3359
                                                                   with
                                                                   | 
                                                                   (_msg,_env,_uvar,term,typ,uu____3377)
                                                                    ->
                                                                    let uu___145_3378
                                                                    = goal in
                                                                    let uu____3379
                                                                    =
                                                                    bnorm
                                                                    goal.FStar_Tactics_Types.context
                                                                    term in
                                                                    let uu____3380
                                                                    =
                                                                    bnorm
                                                                    goal.FStar_Tactics_Types.context
                                                                    typ in
                                                                    {
                                                                    FStar_Tactics_Types.context
                                                                    =
                                                                    (uu___145_3378.FStar_Tactics_Types.context);
                                                                    FStar_Tactics_Types.witness
                                                                    =
                                                                    uu____3379;
                                                                    FStar_Tactics_Types.goal_ty
                                                                    =
                                                                    uu____3380;
                                                                    FStar_Tactics_Types.opts
                                                                    =
                                                                    (uu___145_3378.FStar_Tactics_Types.opts);
                                                                    FStar_Tactics_Types.is_guard
                                                                    =
                                                                    (uu___145_3378.FStar_Tactics_Types.is_guard)
                                                                    })) in
                                                         let rec filter' f xs
                                                           =
                                                           match xs with
                                                           | [] -> []
                                                           | x::xs1 ->
                                                               let uu____3418
                                                                 = f x xs1 in
                                                               if uu____3418
                                                               then
                                                                 let uu____3421
                                                                   =
                                                                   filter' f
                                                                    xs1 in
                                                                 x ::
                                                                   uu____3421
                                                               else
                                                                 filter' f
                                                                   xs1 in
                                                         let sub_goals1 =
                                                           filter'
                                                             (fun g  ->
                                                                fun goals  ->
                                                                  let uu____3435
                                                                    =
                                                                    checkone
                                                                    g.FStar_Tactics_Types.witness
                                                                    goals in
                                                                  Prims.op_Negation
                                                                    uu____3435)
                                                             sub_goals in
                                                         let uu____3436 =
                                                           add_goal_from_guard
                                                             "apply_lemma guard"
                                                             goal.FStar_Tactics_Types.context
                                                             guard
                                                             goal.FStar_Tactics_Types.opts in
                                                         bind uu____3436
                                                           (fun uu____3441 
                                                              ->
                                                              let uu____3442
                                                                =
                                                                let uu____3445
                                                                  =
                                                                  let uu____3446
                                                                    =
                                                                    let uu____3447
                                                                    =
                                                                    FStar_Syntax_Util.mk_squash
                                                                    pre in
                                                                    istrivial
                                                                    goal.FStar_Tactics_Types.context
                                                                    uu____3447 in
                                                                  Prims.op_Negation
                                                                    uu____3446 in
                                                                if uu____3445
                                                                then
                                                                  add_irrelevant_goal
                                                                    "apply_lemma precondition"
                                                                    goal.FStar_Tactics_Types.context
                                                                    pre
                                                                    goal.FStar_Tactics_Types.opts
                                                                else ret () in
                                                              bind uu____3442
                                                                (fun
                                                                   uu____3452
                                                                    ->
                                                                   add_goals
                                                                    sub_goals1))))))))))) in
      focus uu____2532 in
    FStar_All.pipe_left (wrap_err "apply_lemma") uu____2529
let destruct_eq':
  FStar_Syntax_Syntax.typ ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option
  =
  fun typ  ->
    let uu____3473 = FStar_Syntax_Util.destruct_typ_as_formula typ in
    match uu____3473 with
    | FStar_Pervasives_Native.Some (FStar_Syntax_Util.BaseConn
        (l,uu____3483::(e1,uu____3485)::(e2,uu____3487)::[])) when
        FStar_Ident.lid_equals l FStar_Parser_Const.eq2_lid ->
        FStar_Pervasives_Native.Some (e1, e2)
    | uu____3546 -> FStar_Pervasives_Native.None
let destruct_eq:
  FStar_Syntax_Syntax.typ ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option
  =
  fun typ  ->
    let uu____3569 = destruct_eq' typ in
    match uu____3569 with
    | FStar_Pervasives_Native.Some t -> FStar_Pervasives_Native.Some t
    | FStar_Pervasives_Native.None  ->
        let uu____3599 = FStar_Syntax_Util.un_squash typ in
        (match uu____3599 with
         | FStar_Pervasives_Native.Some typ1 -> destruct_eq' typ1
         | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None)
let split_env:
  FStar_Syntax_Syntax.bv ->
    env ->
      (env,FStar_Syntax_Syntax.bv Prims.list) FStar_Pervasives_Native.tuple2
        FStar_Pervasives_Native.option
  =
  fun bvar  ->
    fun e  ->
      let rec aux e1 =
        let uu____3657 = FStar_TypeChecker_Env.pop_bv e1 in
        match uu____3657 with
        | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
        | FStar_Pervasives_Native.Some (bv',e') ->
            if FStar_Syntax_Syntax.bv_eq bvar bv'
            then FStar_Pervasives_Native.Some (e', [])
            else
              (let uu____3705 = aux e' in
               FStar_Util.map_opt uu____3705
                 (fun uu____3729  ->
                    match uu____3729 with | (e'',bvs) -> (e'', (bv' :: bvs)))) in
      let uu____3750 = aux e in
      FStar_Util.map_opt uu____3750
        (fun uu____3774  ->
           match uu____3774 with | (e',bvs) -> (e', (FStar_List.rev bvs)))
let push_bvs:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.bv Prims.list -> FStar_TypeChecker_Env.env
  =
  fun e  ->
    fun bvs  ->
      FStar_List.fold_right
        (fun b  -> fun e1  -> FStar_TypeChecker_Env.push_bv e1 b) bvs e
let subst_goal:
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.bv ->
      FStar_Syntax_Syntax.subst_elt Prims.list ->
        FStar_Tactics_Types.goal ->
          FStar_Tactics_Types.goal FStar_Pervasives_Native.option
  =
  fun b1  ->
    fun b2  ->
      fun s  ->
        fun g  ->
          let uu____3835 = split_env b1 g.FStar_Tactics_Types.context in
          FStar_Util.map_opt uu____3835
            (fun uu____3859  ->
               match uu____3859 with
               | (e0,bvs) ->
                   let s1 bv =
                     let uu___146_3876 = bv in
                     let uu____3877 =
                       FStar_Syntax_Subst.subst s bv.FStar_Syntax_Syntax.sort in
                     {
                       FStar_Syntax_Syntax.ppname =
                         (uu___146_3876.FStar_Syntax_Syntax.ppname);
                       FStar_Syntax_Syntax.index =
                         (uu___146_3876.FStar_Syntax_Syntax.index);
                       FStar_Syntax_Syntax.sort = uu____3877
                     } in
                   let bvs1 = FStar_List.map s1 bvs in
                   let c = push_bvs e0 (b2 :: bvs1) in
                   let w =
                     FStar_Syntax_Subst.subst s g.FStar_Tactics_Types.witness in
                   let t =
                     FStar_Syntax_Subst.subst s g.FStar_Tactics_Types.goal_ty in
                   let uu___147_3886 = g in
                   {
                     FStar_Tactics_Types.context = c;
                     FStar_Tactics_Types.witness = w;
                     FStar_Tactics_Types.goal_ty = t;
                     FStar_Tactics_Types.opts =
                       (uu___147_3886.FStar_Tactics_Types.opts);
                     FStar_Tactics_Types.is_guard =
                       (uu___147_3886.FStar_Tactics_Types.is_guard)
                   })
let rewrite: FStar_Syntax_Syntax.binder -> Prims.unit tac =
  fun h  ->
    bind cur_goal
      (fun goal  ->
         let uu____3900 = h in
         match uu____3900 with
         | (bv,uu____3904) ->
             mlog
               (fun uu____3908  ->
                  let uu____3909 = FStar_Syntax_Print.bv_to_string bv in
                  let uu____3910 =
                    FStar_Syntax_Print.term_to_string
                      bv.FStar_Syntax_Syntax.sort in
                  FStar_Util.print2 "+++Rewrite %s : %s\n" uu____3909
                    uu____3910)
               (fun uu____3913  ->
                  let uu____3914 =
                    split_env bv goal.FStar_Tactics_Types.context in
                  match uu____3914 with
                  | FStar_Pervasives_Native.None  ->
                      fail "rewrite: binder not found in environment"
                  | FStar_Pervasives_Native.Some (e0,bvs) ->
                      let uu____3943 =
                        destruct_eq bv.FStar_Syntax_Syntax.sort in
                      (match uu____3943 with
                       | FStar_Pervasives_Native.Some (x,e) ->
                           let uu____3958 =
                             let uu____3959 = FStar_Syntax_Subst.compress x in
                             uu____3959.FStar_Syntax_Syntax.n in
                           (match uu____3958 with
                            | FStar_Syntax_Syntax.Tm_name x1 ->
                                let s = [FStar_Syntax_Syntax.NT (x1, e)] in
                                let s1 bv1 =
                                  let uu___148_3972 = bv1 in
                                  let uu____3973 =
                                    FStar_Syntax_Subst.subst s
                                      bv1.FStar_Syntax_Syntax.sort in
                                  {
                                    FStar_Syntax_Syntax.ppname =
                                      (uu___148_3972.FStar_Syntax_Syntax.ppname);
                                    FStar_Syntax_Syntax.index =
                                      (uu___148_3972.FStar_Syntax_Syntax.index);
                                    FStar_Syntax_Syntax.sort = uu____3973
                                  } in
                                let bvs1 = FStar_List.map s1 bvs in
                                let uu____3979 =
                                  let uu___149_3980 = goal in
                                  let uu____3981 = push_bvs e0 (bv :: bvs1) in
                                  let uu____3982 =
                                    FStar_Syntax_Subst.subst s
                                      goal.FStar_Tactics_Types.witness in
                                  let uu____3983 =
                                    FStar_Syntax_Subst.subst s
                                      goal.FStar_Tactics_Types.goal_ty in
                                  {
                                    FStar_Tactics_Types.context = uu____3981;
                                    FStar_Tactics_Types.witness = uu____3982;
                                    FStar_Tactics_Types.goal_ty = uu____3983;
                                    FStar_Tactics_Types.opts =
                                      (uu___149_3980.FStar_Tactics_Types.opts);
                                    FStar_Tactics_Types.is_guard =
                                      (uu___149_3980.FStar_Tactics_Types.is_guard)
                                  } in
                                replace_cur uu____3979
                            | uu____3984 ->
                                fail
                                  "rewrite: Not an equality hypothesis with a variable on the LHS")
                       | uu____3985 ->
                           fail "rewrite: Not an equality hypothesis")))
let rename_to: FStar_Syntax_Syntax.binder -> Prims.string -> Prims.unit tac =
  fun b  ->
    fun s  ->
      bind cur_goal
        (fun goal  ->
           let uu____4012 = b in
           match uu____4012 with
           | (bv,uu____4016) ->
               let bv' =
                 FStar_Syntax_Syntax.freshen_bv
                   (let uu___150_4020 = bv in
                    {
                      FStar_Syntax_Syntax.ppname =
                        (FStar_Ident.mk_ident
                           (s,
                             ((bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idRange)));
                      FStar_Syntax_Syntax.index =
                        (uu___150_4020.FStar_Syntax_Syntax.index);
                      FStar_Syntax_Syntax.sort =
                        (uu___150_4020.FStar_Syntax_Syntax.sort)
                    }) in
               let s1 =
                 let uu____4024 =
                   let uu____4025 =
                     let uu____4032 = FStar_Syntax_Syntax.bv_to_name bv' in
                     (bv, uu____4032) in
                   FStar_Syntax_Syntax.NT uu____4025 in
                 [uu____4024] in
               let uu____4033 = subst_goal bv bv' s1 goal in
               (match uu____4033 with
                | FStar_Pervasives_Native.None  ->
                    fail "rename_to: binder not found in environment"
                | FStar_Pervasives_Native.Some goal1 -> replace_cur goal1))
let binder_retype: FStar_Syntax_Syntax.binder -> Prims.unit tac =
  fun b  ->
    bind cur_goal
      (fun goal  ->
         let uu____4053 = b in
         match uu____4053 with
         | (bv,uu____4057) ->
             let uu____4058 = split_env bv goal.FStar_Tactics_Types.context in
             (match uu____4058 with
              | FStar_Pervasives_Native.None  ->
                  fail "binder_retype: binder is not present in environment"
              | FStar_Pervasives_Native.Some (e0,bvs) ->
                  let uu____4087 = FStar_Syntax_Util.type_u () in
                  (match uu____4087 with
                   | (ty,u) ->
                       let uu____4096 = new_uvar "binder_retype" e0 ty in
                       bind uu____4096
                         (fun t'  ->
                            let bv'' =
                              let uu___151_4106 = bv in
                              {
                                FStar_Syntax_Syntax.ppname =
                                  (uu___151_4106.FStar_Syntax_Syntax.ppname);
                                FStar_Syntax_Syntax.index =
                                  (uu___151_4106.FStar_Syntax_Syntax.index);
                                FStar_Syntax_Syntax.sort = t'
                              } in
                            let s =
                              let uu____4110 =
                                let uu____4111 =
                                  let uu____4118 =
                                    FStar_Syntax_Syntax.bv_to_name bv'' in
                                  (bv, uu____4118) in
                                FStar_Syntax_Syntax.NT uu____4111 in
                              [uu____4110] in
                            let bvs1 =
                              FStar_List.map
                                (fun b1  ->
                                   let uu___152_4126 = b1 in
                                   let uu____4127 =
                                     FStar_Syntax_Subst.subst s
                                       b1.FStar_Syntax_Syntax.sort in
                                   {
                                     FStar_Syntax_Syntax.ppname =
                                       (uu___152_4126.FStar_Syntax_Syntax.ppname);
                                     FStar_Syntax_Syntax.index =
                                       (uu___152_4126.FStar_Syntax_Syntax.index);
                                     FStar_Syntax_Syntax.sort = uu____4127
                                   }) bvs in
                            let env' = push_bvs e0 (bv'' :: bvs1) in
                            bind dismiss
                              (fun uu____4133  ->
                                 let uu____4134 =
                                   let uu____4137 =
                                     let uu____4140 =
                                       let uu___153_4141 = goal in
                                       let uu____4142 =
                                         FStar_Syntax_Subst.subst s
                                           goal.FStar_Tactics_Types.witness in
                                       let uu____4143 =
                                         FStar_Syntax_Subst.subst s
                                           goal.FStar_Tactics_Types.goal_ty in
                                       {
                                         FStar_Tactics_Types.context = env';
                                         FStar_Tactics_Types.witness =
                                           uu____4142;
                                         FStar_Tactics_Types.goal_ty =
                                           uu____4143;
                                         FStar_Tactics_Types.opts =
                                           (uu___153_4141.FStar_Tactics_Types.opts);
                                         FStar_Tactics_Types.is_guard =
                                           (uu___153_4141.FStar_Tactics_Types.is_guard)
                                       } in
                                     [uu____4140] in
                                   add_goals uu____4137 in
                                 bind uu____4134
                                   (fun uu____4146  ->
                                      let uu____4147 =
                                        FStar_Syntax_Util.mk_eq2
                                          (FStar_Syntax_Syntax.U_succ u) ty
                                          bv.FStar_Syntax_Syntax.sort t' in
                                      add_irrelevant_goal
                                        "binder_retype equation" e0
                                        uu____4147
                                        goal.FStar_Tactics_Types.opts))))))
let revert: Prims.unit tac =
  bind cur_goal
    (fun goal  ->
       let uu____4153 =
         FStar_TypeChecker_Env.pop_bv goal.FStar_Tactics_Types.context in
       match uu____4153 with
       | FStar_Pervasives_Native.None  -> fail "Cannot revert; empty context"
       | FStar_Pervasives_Native.Some (x,env') ->
           let typ' =
             let uu____4175 =
               FStar_Syntax_Syntax.mk_Total goal.FStar_Tactics_Types.goal_ty in
             FStar_Syntax_Util.arrow [(x, FStar_Pervasives_Native.None)]
               uu____4175 in
           let w' =
             FStar_Syntax_Util.abs [(x, FStar_Pervasives_Native.None)]
               goal.FStar_Tactics_Types.witness FStar_Pervasives_Native.None in
           replace_cur
             (let uu___154_4209 = goal in
              {
                FStar_Tactics_Types.context = env';
                FStar_Tactics_Types.witness = w';
                FStar_Tactics_Types.goal_ty = typ';
                FStar_Tactics_Types.opts =
                  (uu___154_4209.FStar_Tactics_Types.opts);
                FStar_Tactics_Types.is_guard =
                  (uu___154_4209.FStar_Tactics_Types.is_guard)
              }))
let revert_hd: name -> Prims.unit tac =
  fun x  ->
    bind cur_goal
      (fun goal  ->
         let uu____4221 =
           FStar_TypeChecker_Env.pop_bv goal.FStar_Tactics_Types.context in
         match uu____4221 with
         | FStar_Pervasives_Native.None  ->
             fail "Cannot revert_hd; empty context"
         | FStar_Pervasives_Native.Some (y,env') ->
             if Prims.op_Negation (FStar_Syntax_Syntax.bv_eq x y)
             then
               let uu____4242 = FStar_Syntax_Print.bv_to_string x in
               let uu____4243 = FStar_Syntax_Print.bv_to_string y in
               fail2
                 "Cannot revert_hd %s; head variable mismatch ... egot %s"
                 uu____4242 uu____4243
             else revert)
let clear_top: Prims.unit tac =
  bind cur_goal
    (fun goal  ->
       let uu____4250 =
         FStar_TypeChecker_Env.pop_bv goal.FStar_Tactics_Types.context in
       match uu____4250 with
       | FStar_Pervasives_Native.None  -> fail "Cannot clear; empty context"
       | FStar_Pervasives_Native.Some (x,env') ->
           let fns_ty =
             FStar_Syntax_Free.names goal.FStar_Tactics_Types.goal_ty in
           let uu____4272 = FStar_Util.set_mem x fns_ty in
           if uu____4272
           then fail "Cannot clear; variable appears in goal"
           else
             (let uu____4276 =
                new_uvar "clear_top" env' goal.FStar_Tactics_Types.goal_ty in
              bind uu____4276
                (fun u  ->
                   let uu____4282 =
                     let uu____4283 = trysolve goal u in
                     Prims.op_Negation uu____4283 in
                   if uu____4282
                   then fail "clear: unification failed"
                   else
                     (let new_goal =
                        let uu___155_4288 = goal in
                        let uu____4289 = bnorm env' u in
                        {
                          FStar_Tactics_Types.context = env';
                          FStar_Tactics_Types.witness = uu____4289;
                          FStar_Tactics_Types.goal_ty =
                            (uu___155_4288.FStar_Tactics_Types.goal_ty);
                          FStar_Tactics_Types.opts =
                            (uu___155_4288.FStar_Tactics_Types.opts);
                          FStar_Tactics_Types.is_guard =
                            (uu___155_4288.FStar_Tactics_Types.is_guard)
                        } in
                      bind dismiss (fun uu____4291  -> add_goals [new_goal])))))
let rec clear: FStar_Syntax_Syntax.binder -> Prims.unit tac =
  fun b  ->
    bind cur_goal
      (fun goal  ->
         let uu____4303 =
           FStar_TypeChecker_Env.pop_bv goal.FStar_Tactics_Types.context in
         match uu____4303 with
         | FStar_Pervasives_Native.None  ->
             fail "Cannot clear; empty context"
         | FStar_Pervasives_Native.Some (b',env') ->
             if FStar_Syntax_Syntax.bv_eq (FStar_Pervasives_Native.fst b) b'
             then clear_top
             else
               bind revert
                 (fun uu____4327  ->
                    let uu____4328 = clear b in
                    bind uu____4328
                      (fun uu____4332  ->
                         bind intro (fun uu____4334  -> ret ()))))
let prune: Prims.string -> Prims.unit tac =
  fun s  ->
    bind cur_goal
      (fun g  ->
         let ctx = g.FStar_Tactics_Types.context in
         let ctx' =
           FStar_TypeChecker_Env.rem_proof_ns ctx
             (FStar_Ident.path_of_text s) in
         let g' =
           let uu___156_4351 = g in
           {
             FStar_Tactics_Types.context = ctx';
             FStar_Tactics_Types.witness =
               (uu___156_4351.FStar_Tactics_Types.witness);
             FStar_Tactics_Types.goal_ty =
               (uu___156_4351.FStar_Tactics_Types.goal_ty);
             FStar_Tactics_Types.opts =
               (uu___156_4351.FStar_Tactics_Types.opts);
             FStar_Tactics_Types.is_guard =
               (uu___156_4351.FStar_Tactics_Types.is_guard)
           } in
         bind dismiss (fun uu____4353  -> add_goals [g']))
let addns: Prims.string -> Prims.unit tac =
  fun s  ->
    bind cur_goal
      (fun g  ->
         let ctx = g.FStar_Tactics_Types.context in
         let ctx' =
           FStar_TypeChecker_Env.add_proof_ns ctx
             (FStar_Ident.path_of_text s) in
         let g' =
           let uu___157_4370 = g in
           {
             FStar_Tactics_Types.context = ctx';
             FStar_Tactics_Types.witness =
               (uu___157_4370.FStar_Tactics_Types.witness);
             FStar_Tactics_Types.goal_ty =
               (uu___157_4370.FStar_Tactics_Types.goal_ty);
             FStar_Tactics_Types.opts =
               (uu___157_4370.FStar_Tactics_Types.opts);
             FStar_Tactics_Types.is_guard =
               (uu___157_4370.FStar_Tactics_Types.is_guard)
           } in
         bind dismiss (fun uu____4372  -> add_goals [g']))
let rec mapM: 'a 'b . ('a -> 'b tac) -> 'a Prims.list -> 'b Prims.list tac =
  fun f  ->
    fun l  ->
      match l with
      | [] -> ret []
      | x::xs ->
          let uu____4414 = f x in
          bind uu____4414
            (fun y  ->
               let uu____4422 = mapM f xs in
               bind uu____4422 (fun ys  -> ret (y :: ys)))
let rec tac_fold_env:
  FStar_Tactics_Types.direction ->
    (env -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac) ->
      env -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac
  =
  fun d  ->
    fun f  ->
      fun env  ->
        fun t  ->
          let tn =
            let uu____4472 = FStar_Syntax_Subst.compress t in
            uu____4472.FStar_Syntax_Syntax.n in
          let uu____4475 =
            if d = FStar_Tactics_Types.TopDown
            then
              f env
                (let uu___159_4481 = t in
                 {
                   FStar_Syntax_Syntax.n = tn;
                   FStar_Syntax_Syntax.pos =
                     (uu___159_4481.FStar_Syntax_Syntax.pos);
                   FStar_Syntax_Syntax.vars =
                     (uu___159_4481.FStar_Syntax_Syntax.vars)
                 })
            else ret t in
          bind uu____4475
            (fun t1  ->
               let tn1 =
                 match tn with
                 | FStar_Syntax_Syntax.Tm_app (hd1,args) ->
                     let ff = tac_fold_env d f env in
                     let uu____4518 = ff hd1 in
                     bind uu____4518
                       (fun hd2  ->
                          let fa uu____4538 =
                            match uu____4538 with
                            | (a,q) ->
                                let uu____4551 = ff a in
                                bind uu____4551 (fun a1  -> ret (a1, q)) in
                          let uu____4564 = mapM fa args in
                          bind uu____4564
                            (fun args1  ->
                               ret (FStar_Syntax_Syntax.Tm_app (hd2, args1))))
                 | FStar_Syntax_Syntax.Tm_abs (bs,t2,k) ->
                     let uu____4624 = FStar_Syntax_Subst.open_term bs t2 in
                     (match uu____4624 with
                      | (bs1,t') ->
                          let uu____4633 =
                            let uu____4636 =
                              FStar_TypeChecker_Env.push_binders env bs1 in
                            tac_fold_env d f uu____4636 t' in
                          bind uu____4633
                            (fun t''  ->
                               let uu____4640 =
                                 let uu____4641 =
                                   let uu____4658 =
                                     FStar_Syntax_Subst.close_binders bs1 in
                                   let uu____4659 =
                                     FStar_Syntax_Subst.close bs1 t'' in
                                   (uu____4658, uu____4659, k) in
                                 FStar_Syntax_Syntax.Tm_abs uu____4641 in
                               ret uu____4640))
                 | FStar_Syntax_Syntax.Tm_arrow (bs,k) -> ret tn
                 | uu____4680 -> ret tn in
               bind tn1
                 (fun tn2  ->
                    let t' =
                      let uu___158_4687 = t1 in
                      {
                        FStar_Syntax_Syntax.n = tn2;
                        FStar_Syntax_Syntax.pos =
                          (uu___158_4687.FStar_Syntax_Syntax.pos);
                        FStar_Syntax_Syntax.vars =
                          (uu___158_4687.FStar_Syntax_Syntax.vars)
                      } in
                    if d = FStar_Tactics_Types.BottomUp
                    then f env t'
                    else ret t'))
let pointwise_rec:
  FStar_Tactics_Types.proofstate ->
    Prims.unit tac ->
      FStar_Options.optionstate ->
        FStar_TypeChecker_Env.env ->
          FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac
  =
  fun ps  ->
    fun tau  ->
      fun opts  ->
        fun env  ->
          fun t  ->
            let uu____4721 = FStar_TypeChecker_TcTerm.tc_term env t in
            match uu____4721 with
            | (t1,lcomp,g) ->
                let uu____4733 =
                  (let uu____4736 =
                     FStar_Syntax_Util.is_pure_or_ghost_lcomp lcomp in
                   Prims.op_Negation uu____4736) ||
                    (let uu____4738 = FStar_TypeChecker_Rel.is_trivial g in
                     Prims.op_Negation uu____4738) in
                if uu____4733
                then ret t1
                else
                  (let typ = lcomp.FStar_Syntax_Syntax.res_typ in
                   let uu____4745 = new_uvar "pointwise_rec" env typ in
                   bind uu____4745
                     (fun ut  ->
                        log ps
                          (fun uu____4756  ->
                             let uu____4757 =
                               FStar_Syntax_Print.term_to_string t1 in
                             let uu____4758 =
                               FStar_Syntax_Print.term_to_string ut in
                             FStar_Util.print2
                               "Pointwise_rec: making equality %s = %s\n"
                               uu____4757 uu____4758);
                        (let uu____4759 =
                           let uu____4762 =
                             let uu____4763 =
                               FStar_TypeChecker_TcTerm.universe_of env typ in
                             FStar_Syntax_Util.mk_eq2 uu____4763 typ t1 ut in
                           add_irrelevant_goal "pointwise_rec equation" env
                             uu____4762 opts in
                         bind uu____4759
                           (fun uu____4766  ->
                              let uu____4767 =
                                bind tau
                                  (fun uu____4772  ->
                                     let ut1 =
                                       FStar_TypeChecker_Normalize.reduce_uvar_solutions
                                         env ut in
                                     ret ut1) in
                              focus uu____4767))))
let pointwise:
  FStar_Tactics_Types.direction -> Prims.unit tac -> Prims.unit tac =
  fun d  ->
    fun tau  ->
      bind get
        (fun ps  ->
           let uu____4797 =
             match ps.FStar_Tactics_Types.goals with
             | g::gs -> (g, gs)
             | [] -> failwith "Pointwise: no goals" in
           match uu____4797 with
           | (g,gs) ->
               let gt1 = g.FStar_Tactics_Types.goal_ty in
               (log ps
                  (fun uu____4834  ->
                     let uu____4835 = FStar_Syntax_Print.term_to_string gt1 in
                     FStar_Util.print1 "Pointwise starting with %s\n"
                       uu____4835);
                bind dismiss_all
                  (fun uu____4838  ->
                     let uu____4839 =
                       tac_fold_env d
                         (pointwise_rec ps tau g.FStar_Tactics_Types.opts)
                         g.FStar_Tactics_Types.context gt1 in
                     bind uu____4839
                       (fun gt'  ->
                          log ps
                            (fun uu____4849  ->
                               let uu____4850 =
                                 FStar_Syntax_Print.term_to_string gt' in
                               FStar_Util.print1
                                 "Pointwise seems to have succeded with %s\n"
                                 uu____4850);
                          (let uu____4851 = push_goals gs in
                           bind uu____4851
                             (fun uu____4855  ->
                                add_goals
                                  [(let uu___160_4857 = g in
                                    {
                                      FStar_Tactics_Types.context =
                                        (uu___160_4857.FStar_Tactics_Types.context);
                                      FStar_Tactics_Types.witness =
                                        (uu___160_4857.FStar_Tactics_Types.witness);
                                      FStar_Tactics_Types.goal_ty = gt';
                                      FStar_Tactics_Types.opts =
                                        (uu___160_4857.FStar_Tactics_Types.opts);
                                      FStar_Tactics_Types.is_guard =
                                        (uu___160_4857.FStar_Tactics_Types.is_guard)
                                    })]))))))
let trefl: Prims.unit tac =
  bind cur_goal
    (fun g  ->
       let uu____4877 =
         FStar_Syntax_Util.un_squash g.FStar_Tactics_Types.goal_ty in
       match uu____4877 with
       | FStar_Pervasives_Native.Some t ->
           let uu____4889 = FStar_Syntax_Util.head_and_args' t in
           (match uu____4889 with
            | (hd1,args) ->
                let uu____4922 =
                  let uu____4935 =
                    let uu____4936 = FStar_Syntax_Util.un_uinst hd1 in
                    uu____4936.FStar_Syntax_Syntax.n in
                  (uu____4935, args) in
                (match uu____4922 with
                 | (FStar_Syntax_Syntax.Tm_fvar
                    fv,uu____4950::(l,uu____4952)::(r,uu____4954)::[]) when
                     FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.eq2_lid
                     ->
                     let uu____5001 =
                       let uu____5002 =
                         do_unify g.FStar_Tactics_Types.context l r in
                       Prims.op_Negation uu____5002 in
                     if uu____5001
                     then
                       let uu____5005 =
                         FStar_TypeChecker_Normalize.term_to_string
                           g.FStar_Tactics_Types.context l in
                       let uu____5006 =
                         FStar_TypeChecker_Normalize.term_to_string
                           g.FStar_Tactics_Types.context r in
                       fail2 "trefl: not a trivial equality (%s vs %s)"
                         uu____5005 uu____5006
                     else solve g FStar_Syntax_Util.exp_unit
                 | (hd2,uu____5009) ->
                     let uu____5026 =
                       FStar_TypeChecker_Normalize.term_to_string
                         g.FStar_Tactics_Types.context t in
                     fail1 "trefl: not an equality (%s)" uu____5026))
       | FStar_Pervasives_Native.None  -> fail "not an irrelevant goal")
let dup: Prims.unit tac =
  bind cur_goal
    (fun g  ->
       let uu____5034 =
         new_uvar "dup" g.FStar_Tactics_Types.context
           g.FStar_Tactics_Types.goal_ty in
       bind uu____5034
         (fun u  ->
            let g' =
              let uu___161_5041 = g in
              {
                FStar_Tactics_Types.context =
                  (uu___161_5041.FStar_Tactics_Types.context);
                FStar_Tactics_Types.witness = u;
                FStar_Tactics_Types.goal_ty =
                  (uu___161_5041.FStar_Tactics_Types.goal_ty);
                FStar_Tactics_Types.opts =
                  (uu___161_5041.FStar_Tactics_Types.opts);
                FStar_Tactics_Types.is_guard =
                  (uu___161_5041.FStar_Tactics_Types.is_guard)
              } in
            bind dismiss
              (fun uu____5044  ->
                 let uu____5045 =
                   let uu____5048 =
                     let uu____5049 =
                       FStar_TypeChecker_TcTerm.universe_of
                         g.FStar_Tactics_Types.context
                         g.FStar_Tactics_Types.goal_ty in
                     FStar_Syntax_Util.mk_eq2 uu____5049
                       g.FStar_Tactics_Types.goal_ty u
                       g.FStar_Tactics_Types.witness in
                   add_irrelevant_goal "dup equation"
                     g.FStar_Tactics_Types.context uu____5048
                     g.FStar_Tactics_Types.opts in
                 bind uu____5045
                   (fun uu____5052  ->
                      let uu____5053 = add_goals [g'] in
                      bind uu____5053 (fun uu____5057  -> ret ())))))
let flip: Prims.unit tac =
  bind get
    (fun ps  ->
       match ps.FStar_Tactics_Types.goals with
       | g1::g2::gs ->
           set
             (let uu___162_5074 = ps in
              {
                FStar_Tactics_Types.main_context =
                  (uu___162_5074.FStar_Tactics_Types.main_context);
                FStar_Tactics_Types.main_goal =
                  (uu___162_5074.FStar_Tactics_Types.main_goal);
                FStar_Tactics_Types.all_implicits =
                  (uu___162_5074.FStar_Tactics_Types.all_implicits);
                FStar_Tactics_Types.goals = (g2 :: g1 :: gs);
                FStar_Tactics_Types.smt_goals =
                  (uu___162_5074.FStar_Tactics_Types.smt_goals);
                FStar_Tactics_Types.depth =
                  (uu___162_5074.FStar_Tactics_Types.depth);
                FStar_Tactics_Types.__dump =
                  (uu___162_5074.FStar_Tactics_Types.__dump)
              })
       | uu____5075 -> fail "flip: less than 2 goals")
let later: Prims.unit tac =
  bind get
    (fun ps  ->
       match ps.FStar_Tactics_Types.goals with
       | [] -> ret ()
       | g::gs ->
           set
             (let uu___163_5090 = ps in
              {
                FStar_Tactics_Types.main_context =
                  (uu___163_5090.FStar_Tactics_Types.main_context);
                FStar_Tactics_Types.main_goal =
                  (uu___163_5090.FStar_Tactics_Types.main_goal);
                FStar_Tactics_Types.all_implicits =
                  (uu___163_5090.FStar_Tactics_Types.all_implicits);
                FStar_Tactics_Types.goals = (FStar_List.append gs [g]);
                FStar_Tactics_Types.smt_goals =
                  (uu___163_5090.FStar_Tactics_Types.smt_goals);
                FStar_Tactics_Types.depth =
                  (uu___163_5090.FStar_Tactics_Types.depth);
                FStar_Tactics_Types.__dump =
                  (uu___163_5090.FStar_Tactics_Types.__dump)
              }))
let qed: Prims.unit tac =
  bind get
    (fun ps  ->
       match ps.FStar_Tactics_Types.goals with
       | [] -> ret ()
       | uu____5097 -> fail "Not done!")
let cases:
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2 tac
  =
  fun t  ->
    let uu____5116 =
      bind cur_goal
        (fun g  ->
           let uu____5130 = __tc g.FStar_Tactics_Types.context t in
           bind uu____5130
             (fun uu____5166  ->
                match uu____5166 with
                | (t1,typ,guard) ->
                    let uu____5182 = FStar_Syntax_Util.head_and_args typ in
                    (match uu____5182 with
                     | (hd1,args) ->
                         let uu____5225 =
                           let uu____5238 =
                             let uu____5239 = FStar_Syntax_Util.un_uinst hd1 in
                             uu____5239.FStar_Syntax_Syntax.n in
                           (uu____5238, args) in
                         (match uu____5225 with
                          | (FStar_Syntax_Syntax.Tm_fvar
                             fv,(p,uu____5258)::(q,uu____5260)::[]) when
                              FStar_Syntax_Syntax.fv_eq_lid fv
                                FStar_Parser_Const.or_lid
                              ->
                              let v_p =
                                FStar_Syntax_Syntax.new_bv
                                  FStar_Pervasives_Native.None p in
                              let v_q =
                                FStar_Syntax_Syntax.new_bv
                                  FStar_Pervasives_Native.None q in
                              let g1 =
                                let uu___164_5298 = g in
                                let uu____5299 =
                                  FStar_TypeChecker_Env.push_bv
                                    g.FStar_Tactics_Types.context v_p in
                                {
                                  FStar_Tactics_Types.context = uu____5299;
                                  FStar_Tactics_Types.witness =
                                    (uu___164_5298.FStar_Tactics_Types.witness);
                                  FStar_Tactics_Types.goal_ty =
                                    (uu___164_5298.FStar_Tactics_Types.goal_ty);
                                  FStar_Tactics_Types.opts =
                                    (uu___164_5298.FStar_Tactics_Types.opts);
                                  FStar_Tactics_Types.is_guard =
                                    (uu___164_5298.FStar_Tactics_Types.is_guard)
                                } in
                              let g2 =
                                let uu___165_5301 = g in
                                let uu____5302 =
                                  FStar_TypeChecker_Env.push_bv
                                    g.FStar_Tactics_Types.context v_q in
                                {
                                  FStar_Tactics_Types.context = uu____5302;
                                  FStar_Tactics_Types.witness =
                                    (uu___165_5301.FStar_Tactics_Types.witness);
                                  FStar_Tactics_Types.goal_ty =
                                    (uu___165_5301.FStar_Tactics_Types.goal_ty);
                                  FStar_Tactics_Types.opts =
                                    (uu___165_5301.FStar_Tactics_Types.opts);
                                  FStar_Tactics_Types.is_guard =
                                    (uu___165_5301.FStar_Tactics_Types.is_guard)
                                } in
                              bind dismiss
                                (fun uu____5309  ->
                                   let uu____5310 = add_goals [g1; g2] in
                                   bind uu____5310
                                     (fun uu____5319  ->
                                        let uu____5320 =
                                          let uu____5325 =
                                            FStar_Syntax_Syntax.bv_to_name
                                              v_p in
                                          let uu____5326 =
                                            FStar_Syntax_Syntax.bv_to_name
                                              v_q in
                                          (uu____5325, uu____5326) in
                                        ret uu____5320))
                          | uu____5331 ->
                              let uu____5344 =
                                FStar_TypeChecker_Normalize.term_to_string
                                  g.FStar_Tactics_Types.context typ in
                              fail1 "Not a disjunction: %s" uu____5344)))) in
    FStar_All.pipe_left (wrap_err "cases") uu____5116
let set_options: Prims.string -> Prims.unit tac =
  fun s  ->
    bind cur_goal
      (fun g  ->
         FStar_Options.push ();
         (let uu____5383 = FStar_Util.smap_copy g.FStar_Tactics_Types.opts in
          FStar_Options.set uu____5383);
         (let res = FStar_Options.set_options FStar_Options.Set s in
          let opts' = FStar_Options.peek () in
          FStar_Options.pop ();
          (match res with
           | FStar_Getopt.Success  ->
               let g' =
                 let uu___166_5390 = g in
                 {
                   FStar_Tactics_Types.context =
                     (uu___166_5390.FStar_Tactics_Types.context);
                   FStar_Tactics_Types.witness =
                     (uu___166_5390.FStar_Tactics_Types.witness);
                   FStar_Tactics_Types.goal_ty =
                     (uu___166_5390.FStar_Tactics_Types.goal_ty);
                   FStar_Tactics_Types.opts = opts';
                   FStar_Tactics_Types.is_guard =
                     (uu___166_5390.FStar_Tactics_Types.is_guard)
                 } in
               replace_cur g'
           | FStar_Getopt.Error err1 ->
               fail2 "Setting options `%s` failed: %s" s err1
           | FStar_Getopt.Help  ->
               fail1 "Setting options `%s` failed (got `Help`?)" s)))
let top_env: FStar_TypeChecker_Env.env tac =
  bind get
    (fun ps  -> FStar_All.pipe_left ret ps.FStar_Tactics_Types.main_context)
let cur_env: FStar_TypeChecker_Env.env tac =
  bind cur_goal
    (fun g  -> FStar_All.pipe_left ret g.FStar_Tactics_Types.context)
let cur_goal': FStar_Syntax_Syntax.typ tac =
  bind cur_goal
    (fun g  -> FStar_All.pipe_left ret g.FStar_Tactics_Types.goal_ty)
let cur_witness: FStar_Syntax_Syntax.term tac =
  bind cur_goal
    (fun g  -> FStar_All.pipe_left ret g.FStar_Tactics_Types.witness)
let unquote:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac
  =
  fun ty  ->
    fun tm  ->
      let uu____5428 =
        bind cur_goal
          (fun goal  ->
             let env =
               FStar_TypeChecker_Env.set_expected_typ
                 goal.FStar_Tactics_Types.context ty in
             let uu____5436 = __tc env tm in
             bind uu____5436
               (fun uu____5456  ->
                  match uu____5456 with
                  | (tm1,typ,guard) ->
                      (FStar_TypeChecker_Rel.force_trivial_guard env guard;
                       ret tm1))) in
      FStar_All.pipe_left (wrap_err "unquote") uu____5428
let uvar_env:
  env ->
    FStar_Syntax_Syntax.typ FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.term tac
  =
  fun env  ->
    fun ty  ->
      let uu____5489 =
        match ty with
        | FStar_Pervasives_Native.Some ty1 -> ret ty1
        | FStar_Pervasives_Native.None  ->
            let uu____5495 =
              let uu____5496 = FStar_Syntax_Util.type_u () in
              FStar_All.pipe_left FStar_Pervasives_Native.fst uu____5496 in
            new_uvar "uvar_env.2" env uu____5495 in
      bind uu____5489
        (fun typ  ->
           let uu____5508 = new_uvar "uvar_env" env typ in
           bind uu____5508 (fun t  -> ret t))
let unshelve: FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun t  ->
    let uu____5521 =
      bind cur_goal
        (fun goal  ->
           let uu____5527 = __tc goal.FStar_Tactics_Types.context t in
           bind uu____5527
             (fun uu____5547  ->
                match uu____5547 with
                | (t1,typ,guard) ->
                    let uu____5559 =
                      let uu____5560 =
                        let uu____5561 =
                          FStar_TypeChecker_Rel.discharge_guard
                            goal.FStar_Tactics_Types.context guard in
                        FStar_All.pipe_left FStar_TypeChecker_Rel.is_trivial
                          uu____5561 in
                      Prims.op_Negation uu____5560 in
                    if uu____5559
                    then fail "got non-trivial guard"
                    else
                      (let uu____5565 =
                         let uu____5568 =
                           let uu___167_5569 = goal in
                           let uu____5570 =
                             bnorm goal.FStar_Tactics_Types.context t1 in
                           let uu____5571 =
                             bnorm goal.FStar_Tactics_Types.context typ in
                           {
                             FStar_Tactics_Types.context =
                               (uu___167_5569.FStar_Tactics_Types.context);
                             FStar_Tactics_Types.witness = uu____5570;
                             FStar_Tactics_Types.goal_ty = uu____5571;
                             FStar_Tactics_Types.opts =
                               (uu___167_5569.FStar_Tactics_Types.opts);
                             FStar_Tactics_Types.is_guard = false
                           } in
                         [uu____5568] in
                       add_goals uu____5565))) in
    FStar_All.pipe_left (wrap_err "unshelve") uu____5521
let unify:
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool tac =
  fun t1  ->
    fun t2  ->
      bind get
        (fun ps  ->
           let uu____5591 =
             do_unify ps.FStar_Tactics_Types.main_context t1 t2 in
           ret uu____5591)
let launch_process:
  Prims.string -> Prims.string -> Prims.string -> Prims.string tac =
  fun prog  ->
    fun args  ->
      fun input  ->
        bind idtac
          (fun uu____5611  ->
             let uu____5612 = FStar_Options.unsafe_tactic_exec () in
             if uu____5612
             then
               let s =
                 FStar_Util.launch_process true "tactic_launch" prog args
                   input (fun uu____5618  -> fun uu____5619  -> false) in
               ret s
             else
               fail
                 "launch_process: will not run anything unless --unsafe_tactic_exec is provided")
let goal_of_goal_ty:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      (FStar_Tactics_Types.goal,FStar_TypeChecker_Env.guard_t)
        FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun typ  ->
      let uu____5641 =
        FStar_TypeChecker_Util.new_implicit_var "proofstate_of_goal_ty"
          typ.FStar_Syntax_Syntax.pos env typ in
      match uu____5641 with
      | (u,uu____5659,g_u) ->
          let g =
            let uu____5674 = FStar_Options.peek () in
            {
              FStar_Tactics_Types.context = env;
              FStar_Tactics_Types.witness = u;
              FStar_Tactics_Types.goal_ty = typ;
              FStar_Tactics_Types.opts = uu____5674;
              FStar_Tactics_Types.is_guard = false
            } in
          (g, g_u)
let proofstate_of_goal_ty:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      (FStar_Tactics_Types.proofstate,FStar_Syntax_Syntax.term)
        FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun typ  ->
      let uu____5691 = goal_of_goal_ty env typ in
      match uu____5691 with
      | (g,g_u) ->
          let ps =
            {
              FStar_Tactics_Types.main_context = env;
              FStar_Tactics_Types.main_goal = g;
              FStar_Tactics_Types.all_implicits =
                (g_u.FStar_TypeChecker_Env.implicits);
              FStar_Tactics_Types.goals = [g];
              FStar_Tactics_Types.smt_goals = [];
              FStar_Tactics_Types.depth = (Prims.parse_int "0");
              FStar_Tactics_Types.__dump = dump_proofstate
            } in
          (ps, (g.FStar_Tactics_Types.witness))