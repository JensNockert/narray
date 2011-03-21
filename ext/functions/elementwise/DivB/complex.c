type1 x = *input_1;

typer a = input_2->r * input_2->r + input_2->i * input_2->i;
output->r = (x.r * input_2->r + x.i * input_2->i)/a;
output->i = (x.i * input_2->r - x.r * input_2->i)/a;