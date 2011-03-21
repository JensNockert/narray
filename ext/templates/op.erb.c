/*
  na_op.c
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
/* isalpha(3) etc. */
#include <ctype.h>

const int na_upcast[NA_NTYPES][NA_NTYPES] = {
	<%= NGenerator::Type.in_order.map { |x| x.cast_table }.join(",\n\t") %>
};

const int na_no_cast[NA_NTYPES] =
 { <%= NGenerator::Type.in_order.map { |x| NGenerator::Type.in_order.index(x) }.join(", ") %> };
const int na_cast_real[NA_NTYPES] =
 { <%= NGenerator::Type.in_order.map { |x| NGenerator::Type.in_order.index(x.real) }.join(", ") %> };
const int na_cast_comp[NA_NTYPES] =
 { <%= NGenerator::Type.in_order.map { |x| NGenerator::Type.in_order.index(x.complex) }.join(", ") %> };
const int na_cast_round[NA_NTYPES] =
 { <%= NGenerator::Type.in_order.map { |x| NGenerator::Type.in_order.index(x.integer) }.join(", ") %> };
const int na_cast_byte[NA_NTYPES] =
 { <%= NGenerator::Type.in_order.map { |x| x.id == :none ? 0 : 1 }.join(", ") %> };

static void TpErr(void) {
    rb_raise(rb_eTypeError,"illegal operation with this type");
}
static int TpErrI(void) {
    rb_raise(rb_eTypeError,"illegal operation with this type");
    return 0;
}
static void na_zerodiv() {
    rb_raise(rb_eZeroDivError, "divided by 0");
}

static int notnanF(float *n)
{
  return *n == *n;
}
static int notnanD(double *n)
{
  return *n == *n;
}

/* from numeric.c */
static void na_str_append_fp(char *buf)
{
	if (buf[0]=='-' || buf[0]=='+') {
		++buf;
	}
	
	if (ISALPHA(buf[0])) {
		return; /* NaN or Inf */
	}
	
	if (strchr(buf, '.') == 0) {
		size_t len = strlen(buf);
		char * ind = strchr(buf, 'e');
		
		if (ind) {
			memmove(ind+2, ind, len-(ind-buf)+1);
			ind[0] = '.';
			ind[1] = '0';
		} else {
			strcat(buf, ".0");
		}
	}
}

<% NOps.each do |f| %>
/* ------------------------- <%= f[:name] %> --------------------------- */
<% f.implementations.each do |implementation| %>
<%= implementation.prototype %>
<%= implementation.code %>
<% end %>
<%= f.implementation_array if f.public?%>
<% end %>

/* ------------------------- H2N --------------------------- */
#ifdef WORDS_BIGENDIAN

na_func_t H2NFuncs =
{ TpErr, SetBB, SetII, SetLL, SetFF, SetDD, SetXX, SetCC, SetOO };

na_func_t H2VFuncs =
{ TpErr, SetBB, SwpI, SwpL, SwpF, SwpD, SwpX, SwpC, SetOO };

#else
#ifdef DYNAMIC_ENDIAN  /* not supported yet */
#else  /* LITTLE ENDIAN */

na_func_t H2NFuncs =
{ TpErr, SetBB, SwpI, SwpL, SwpF, SwpD, SwpX, SwpC, SetOO };

na_func_t H2VFuncs =
{ TpErr, SetBB, SetII, SetLL, SetFF, SetDD, SetXX, SetCC, SetOO };

#endif
#endif

/* ------------------------- SortIdx --------------------------- */
static int SortIdxB(const void *p1, const void *p2)
{ if (**(u_int8_t**)p1 > **(u_int8_t**)p2) return 1;
  if (**(u_int8_t**)p1 < **(u_int8_t**)p2) return -1;
  return 0; }
static int SortIdxI(const void *p1, const void *p2)
{ if (**(int16_t**)p1 > **(int16_t**)p2) return 1;
  if (**(int16_t**)p1 < **(int16_t**)p2) return -1;
  return 0; }
static int SortIdxL(const void *p1, const void *p2)
{ if (**(int32_t**)p1 > **(int32_t**)p2) return 1;
  if (**(int32_t**)p1 < **(int32_t**)p2) return -1;
  return 0; }
static int SortIdxF(const void *p1, const void *p2)
{ if (**(float**)p1 > **(float**)p2) return 1;
  if (**(float**)p1 < **(float**)p2) return -1;
  return 0; }
static int SortIdxD(const void *p1, const void *p2)
{ if (**(double**)p1 > **(double**)p2) return 1;
  if (**(double**)p1 < **(double**)p2) return -1;
  return 0; }
static int SortIdxO(const void *p1, const void *p2)
{ VALUE r = rb_funcall(**(VALUE**)p1, na_id_compare, 1, **(VALUE**)p2);
  return NUM2INT(r); }

na_sortfunc_t SortIdxFuncs =
{ (int (*)(const void *, const void *))TpErrI, SortIdxB, SortIdxI, SortIdxL, SortIdxF, SortIdxD, (int (*)(const void *, const void *))TpErrI, (int (*)(const void *, const void *))TpErrI, SortIdxO };
