{
	typed x = *input_1;
	typer tmp;
	square#C(&x, &x);
	x.r = 1 - x.r;
	x.i =   - x.i;
	sqrt#C(&x, &x);
	tmp =  x.r + input_1->i;
	x.r = -x.i + input_1->r;
	x.i = tmp;
	log#C(&x, &x);
	output->r =  x.i;
	output->i = -x.r;
}