{
	typed x = *input_1;
	square#C(&x, &x);
	x.r = 1 - x.r;
	x.i =   - x.i;
	sqrt#C(&x, &x);
	x.r -= input_1->i;
	x.i += input_1->r;
	log#C(&x, &x);
	output->r =  x.i;
	output->i = -x.r;
}