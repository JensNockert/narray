type1 x = *output;

typer a = input_1->r * input_1->r + input_1->i * input_1->i;

output->r = (x.r * input_1->r + x.i * input_1->i) / a;
output->i = (x.i * input_1->r - x.r * input_1->i) / a;