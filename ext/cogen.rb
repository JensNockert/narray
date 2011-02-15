require "erb"
require "./preproc"

load ARGV[0]

ERB.new(File.read("erb/head.c")).run

def_method "extract"

cast_numeric
cast_array

if $is_complex
  cast_from "DComplex","dcomplex","m_from_dcomplex"
  cast_from "SComplex","scomplex","m_from_scomplex"
end
cast_from "DFloat","double","m_from_real"
cast_from "SFloat","float","m_from_real"
cast_from "Int64","int64_t","m_from_real"
cast_from "Int32","int32_t","m_from_real"
cast_from "Int16","int16_t","m_from_real"
cast_from "Int8", "int8_t","m_from_real"
cast_from "UInt64","u_int64_t","m_from_real"
cast_from "UInt32","u_int32_t","m_from_real"
cast_from "UInt16","u_int16_t","m_from_real"
cast_from "UInt8", "u_int8_t","m_from_real"

def_singleton "cast", 1

def_method "coerce_cast",1
def_method "to_a"
def_method "fill",1
def_method "format",-1
def_method "format_to_a",-1
def_method "inspect"

# arith

unary2 "abs", "rtype", "cRT"

binary "add"
binary "sub"
binary "mul"
binary "div"

#if $is_int
#  def_func "pow","powint"
#end
pow

unary "minus"
unary "inverse"

# complex

if $is_complex
  unary "conj"
  unary "im"
  unary2 "real", "rtype", "cRT"
  unary2 "imag", "rtype", "cRT"
  unary2 "arg",  "rtype", "cRT"
  def_alias "angle","arg"
  set2 "set_imag", "rtype", "cRT"
  set2 "set_real", "rtype", "cRT"
  def_alias "imag=","set_imag"
  def_alias "real=","set_real"
else
  def_alias "conj", "copy"
  def_alias "im", "copy"
end

def_alias "conjugate","conj"

# base_cond

cond_binary "eq"
cond_binary "ne"

# nearly_eq  : x=~y is true if |x-y| <= (|x|+|y|)*epsilon
if $is_float
  cond_binary "nearly_eq"
else
  def_alias "nearly_eq", "eq"
end

# int
if $is_int
  binary "bit_and"
  binary "bit_or"
  binary "bit_xor"
  unary  "bit_not"
  def_alias "floor", "copy"
  def_alias "round", "copy"
  def_alias "ceil",  "copy"
end

if $is_float && $is_real
  unary "floor"
  unary "round"
  unary "ceil"
end

if $is_comparable
  cond_binary "gt"
  cond_binary "ge"
  cond_binary "lt"
  cond_binary "le"
  def_alias ">", "gt"
  def_alias ">=","ge"
  def_alias "<", "lt"
  def_alias "<=","le"
end

# float

if $is_float
  cond_unary "isnan"
  cond_unary "isinf"
  cond_unary "isfinite"
end

accum "sum"
if $is_comparable
  accum "min"
  accum "max"
end

# dot

# min_index
# max_index
# minmax

# mean
# stddev
# rms
# rmsdev
# cumsum
# prod
# cumprod

def_method "seq",-1
def_method "rand"

# y = a[0] + a[1]*x + a[2]*x^2 + a[3]*x^3 + ... + a[n]*x^n
def_method "poly",-2

if $is_comparable
  qsort $type_name,"dtype","*(dtype*)"
  def_method "sort",-1
  qsort $type_name+"_index","dtype*","**(dtype**)"
  def_method "sort_index",-1
  def_method "median",-1
end

# Math
# histogram

if $has_math
  math "sqrt"
  math "cbrt"
  math "log"
  math "log2"
  math "log10"
  math "exp"
  math "exp2"
  math "exp10"
  math "sin"
  math "cos"
  math "tan"
  math "asin"
  math "acos"
  math "atan"
  math "sinh"
  math "cosh"
  math "tanh"
  math "asinh"
  math "acosh"
  math "atanh"
end
if $has_math && !$is_complex
  math "atan2",2
  math "hypot",2
  math "erf"
  math "erfc"
  math "ldexp",2
end

put_init
