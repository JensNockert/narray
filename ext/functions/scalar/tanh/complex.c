{
	typer d, th;
	output->r = th = tanh(2*input_1->r);
	output->i = sqrt(1-th*th); /* sech */
	d  = 1 + cos(2*input_1->i) * output->i;
	output->r /= d;
	output->i *= sin(2*input_1->i)/d;
}