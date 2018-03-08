module FStar.Reflection.Types

assume new type binder
assume new type term
assume new type env
assume new type fv
assume new type comp
assume new type sigelt

type name : eqtype = list string
type typ     = term
type binders = list binder
