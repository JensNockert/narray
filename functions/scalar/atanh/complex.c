{
	typed x,y;
	x.r=1-input_1->r; x.i=-input_1->i;
	y.r=1+input_1->r; y.i= input_1->i;
	div#C(&y, &y, &x);
	log#C(&x, &y);
	output->r = x.r/2;
	output->i = x.i/2;
}