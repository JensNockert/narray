{
	type1 r = 1, x = *input_1;
	type2 p = *input_2;
	
	switch(p) {
	case 3:
		r *= x;
	case 2:
		r *= x;
	case 1:
		r *= x;
	case 0:
		break;
	default:
		if (p < 0) {
			r = 0;
			break;
		} else {
			while (p) {
				if (p % 2 == 1 ) {
					r *= x;
				}
			
				x *= x; p /= 2;
			}
		}
	}
	
	*output = r;
}
