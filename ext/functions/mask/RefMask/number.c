if (mask) {
	*output = *input_1;
	output += output_stride;
}

mask += mask_stride; input_1 += input_1_stride;