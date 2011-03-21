{
	typed x, y;
	x.r=-input_1->r; x.i=1-input_1->i;
	y.r= input_1->r; y.i=1+input_1->i;
	div#C(&y, &y, &x);
	log#C(&x, &y);
	output->r = -x.i/2;
	output->i =  x.r/2;
}