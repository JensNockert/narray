type1 x = *input_1;

output->r = x.r * input_2->r - x.i * input_2->i;
output->i = x.r * input_2->i + x.i * input_2->r;