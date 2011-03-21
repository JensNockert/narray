if (mask) {
	*output = *input_1;
	input_1 += input_1_stride;
}

mask += mask_stride;
output += output_stride;