{
	typed x = *input_1;
	output->r = log(hypot(x.r, x.i));
	output->i = atan2(x.i, x.r);
}