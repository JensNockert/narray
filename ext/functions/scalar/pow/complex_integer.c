{
	type1 r = {1, 0}, x = *input_1;
	type2 p = *input_2;
	
	switch(p) {
	case 0:
		break;
	case 1:
		r = x;
	case 2:
		square#C(&r, &x);
	default:
		if (p < 0) {
			p = -p;
			pow#CC(&x, input_1, &p);
			recip#C(&x, &x);
			break;
		} else {
			while (p) {
				if (p % 2 == 1 ) {
					mul#C(&r, &r, &x);
				}
			
				square#C(&x, &x); p /= 2;
			}
		}
	}
	
	*output = r;
}