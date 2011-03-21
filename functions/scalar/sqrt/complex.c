{
	typer xr=input_1->r/2, xi=input_1->i/2, r=hypot(xr,xi);
	
	if (xr>0) {
		output->r = sqrt(r+xr);
		output->i = xi/output->r;
	} else if ( (r-=xr) ) {
		output->i = (xi>=0) ? sqrt(r):-sqrt(r);
		output->r = xi/output->i;
	} else {
		output->r = output->i = 0;
	}
}