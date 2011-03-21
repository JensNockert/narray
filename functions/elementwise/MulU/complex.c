type1 x = *output;

output->r = x.r * input_1->r - x.i * input_1->i;
output->i = x.r * input_1->i + x.i * input_1->r;