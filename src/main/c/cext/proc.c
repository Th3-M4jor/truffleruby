/*
 * Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved. This
 * code is released under a tri EPL/GPL/LGPL license. You can use it,
 * redistribute it and/or modify it under the terms of the:
 *
 * Eclipse Public License version 2.0, or
 * GNU General Public License version 2, or
 * GNU Lesser General Public License version 2.1.
 */
#include <truffleruby-impl.h>

// Proc, rb_proc_*

VALUE rb_proc_new(VALUE (*function)(ANYARGS), VALUE value) {
  return rb_tr_wrap(polyglot_invoke(RUBY_CEXT, "rb_proc_new", function, rb_tr_unwrap(value)));
}

VALUE rb_proc_call(VALUE self, VALUE args) {
  return RUBY_CEXT_INVOKE("rb_proc_call", self, args);
}

int rb_proc_arity(VALUE self) {
  return polyglot_as_i32(RUBY_INVOKE_NO_WRAP(self, "arity"));
}

VALUE rb_obj_is_proc(VALUE proc) {
  return rb_obj_is_kind_of(proc, rb_cProc);
}
