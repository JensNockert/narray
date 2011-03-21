/*
  na_math.c
  Automatically generated code
  Numerical Array Extention for Ruby
    (C) Copyright 1999-2008 by Masahiro TANAKA

  This program is free software.
  You can distribute/modify this program
  under the same terms as Ruby itself.
  NO WARRANTY.
*/
#include <ruby.h>
#include "narray.h"
#include "narray_local.h"

#ifndef M_LOG2E
#define M_LOG2E         1.4426950408889634074
#endif
#ifndef M_LOG10E
#define M_LOG10E        0.43429448190325182765
#endif

VALUE rb_mNMath;

static void TpErr(void) {
    rb_raise(rb_eTypeError, "illegal operation with this type");
}

#ifndef HAVE_ACOSH
#include "missing/acosh.c"
#endif

<% NFunctions.each do |f| %>
/* ------------------------- <%= f[:name] %> --------------------------- */
<% f.implementations.each do |implementation| %>
<%= implementation.prototype %>
<%= implementation.code %>
<% end %>
<%= f.implementation_array if f.public?%>
<% end %>

/* ------------------------- Execution -------------------------- */

static void
 na_exec_math(struct NARRAY *a1, struct NARRAY *a2, void (*func)())
{
  int  i, s1, s2;
  char *p1, *p2;

  s1 = na_sizeof[a1->type];
  s2 = na_sizeof[a2->type];
  p1 = a1->ptr;
  p2 = a2->ptr;
  for (i=a1->total; i ; i--) {
    (*func)( p1, p2 );
    p1 += s1;
    p2 += s2;
  }
}


static VALUE
 na_math_func(volatile VALUE self, na_mathfunc_t funcs)
{
  struct NARRAY *a1, *a2;
  VALUE ans;

  if (TYPE(self) == T_ARRAY) {
    self = na_ary_to_nary(self,cNArray);
  } else
  if (!IsNArray(self)) {
    self = na_make_scalar(self,na_object_type(self));
  }

  GetNArray(self,a2);
  if (NA_IsINTEGER(a2)) {
    self = na_upcast_type(self,NA_DFLOAT);
    GetNArray(self,a2);
  }
  ans = na_make_object(a2->type, a2->rank, a2->shape, CLASS_OF(self));
  GetNArray(ans,a1);

  na_exec_math(a1, a2, funcs[a2->type]);

  if (CLASS_OF(self) == cNArrayScalar)
    SetFuncs[NA_ROBJ][a1->type](1,&ans,0,a1->ptr,0);    

  return ans;
}

/* ------------------------- Module Methods -------------------------- */

<% NFunctions.select { |f| f.public? && f.kind == :scalar }.each do |f| %>
/* <%= f[:documentation] %> */
static VALUE
na_math_<%= f.name %>(VALUE obj, VALUE x)
{
	return na_math_func(x, <%= f.name %>Funcs);
}
<% end %>

/* Initialization of NMath module */
void Init_nmath(void)
{
	/* define NMath module */
	rb_mNMath = rb_define_module("NMath");
	
	/* methods */
<% NFunctions.select { |f| f.public? && f.kind == :scalar }.each do |f| %>	rb_define_module_function(rb_mNMath, "<%= f.name %>", na_math_<%= f.name %>, 1);
<% end %>
}