type1 r, d;

if (*input_2==0) {
	output->r = 1;
	output->i = 0;
} else {
	if (input_1->r == 0 && input_1->i == 0 && *input_2 > 0) {
		output->r = 0;
		output->i = 0;
	} else {
		log#C(&r, input_1);
		
		r.r *= *input_2;
		r.i *= *input_2;
		
		exp#C(&d, &r);
		
		output->r = d.r;
		output->i = d.i;
	}
}
