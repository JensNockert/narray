{
	typer d, th;
	output->i = th = tanh(2*input_1->i);
	output->r = sqrt(1-th*th); /* sech */
	d  = 1 + cos(2*input_1->r) * output->r;
	output->r *= sin(2*input_1->r)/d;
	output->i /= d;
}