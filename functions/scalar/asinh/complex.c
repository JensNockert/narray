{
	typed x = *input_1;
	square#C(&x, &x);
	x.r += 1;
	sqrt#C(&x, &x);
	x.r += input_1->r;
	x.i += input_1->i;
	log#C(output, &x);
}