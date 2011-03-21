/*
  acosh.h
  Numerical Array Extention for Ruby
    (C) Copyright 1999-2008 by Masahiro TANAKA

  This program is free software.
  You can distribute/modify this program
  under the same terms as Ruby itself.
  NO WARRANTY.
*/
static double rb_log1p (const double x)
{
  double y;
  y = 1+x;

  if (y==1)
     return x;
  else
     return log(y)*(x/(y-1));
}

static double zero=0;

static double acosh(double x)
{
   /* acosh(x) = log(x+sqrt(x*x-1)) */
   if (x>2) {
      return log(2*x-1/(sqrt(x*x-1)+x));
   } else if (x>=1) {
      x-=1;
      return rb_log1p(x+sqrt(2*x+x*x));
   }
   return zero/(x-x); /* x<1: NaN */
}

static double asinh(double x)
{
   double a, x2;
   int neg;

   /* asinh(x) = log(x+sqrt(x*x+1)) */
   neg = x<0;
   if (neg) {x=-x;}
   x2 = x*x;

   if (x>2) {
      a = log(2*x+1/(x+sqrt(x2+1)));
   } else {
      a = rb_log1p(x+x2/(1+sqrt(x2+1)));
   }
   if (neg) {a=-a;}
   return a;
}

static double atanh(double x)
{
   double a, x2;
   int neg;

   /* atanh(x) = 0.5*log((1+x)/(1-x)) */
   neg = x<0;
   if (neg) {x=-x;}
   x2 = x*2;

   if (x<0.5) {
      a = 0.5*rb_log1p(x2+x2*x/(1-x));
   } else if (x<1) {
      a = 0.5*rb_log1p(x2/(1-x));
   } else if (x==1) {
      a = 1/zero;        /* Infinity */
   } else {
      return zero/(x-x); /* x>1: NaN */
   }
   if (neg) {a=-a;}
   return a;
}
