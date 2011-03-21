if (*input_1 >= 0) {
	*output = floor(*input_1 + 0.5);
} else {
	*output = ceil(*input_1 - 0.5);
}