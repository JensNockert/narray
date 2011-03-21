typed l, r, d;

if (input_2->r == 0 && input_2->i == 0) {
	output->r = 1; output->i = 0;
} else {
	if (input_1->r == 0 && input_1->i == 0 && input_2->r > 0 && input_2->i == 0) {
		output->r=0; output->i=0;
	} else {
		log#C(&l, input_1);
		
		r.r = input_2->r * l.r - input_2->i * l.i;
		r.i = input_2->r * l.i + input_2->i * l.r;
		
		exp#C(&d, &r);
		
		output->r = d.r;
		output->i = d.i;
	}
}