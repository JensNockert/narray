{
	typed r; typer n;
	
	if ( (input_1->r < 0 ? -input_1->r : input_1->r) > (input_1->i < 0 ? -input_1->i : input_1->i) ) {
	  r.i  = input_1->i / input_1->r;
	  n    = (1+r.i*r.i) * input_1->r;
	  r.r  = 1/n;
	  r.i /= -n;
	} else {
	  r.r  = input_1->r / input_1->i;
	  n    = (1+r.r*r.r) * input_1->i;
	  r.r /= n;
	  r.i  = -1/n;
	}
	
	*output = r;
}
