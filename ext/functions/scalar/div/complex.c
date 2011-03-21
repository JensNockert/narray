{
	typer a = input_2->r * input_2->r + input_2->i * input_2->i;
	
	output->r = (input_1->r * input_2->r + input_1->i * input_2->i) / a;
	output->i = (input_1->i * input_2->r - input_1->r * input_2->i) / a;
}
