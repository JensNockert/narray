if (FIX2INT(rb_funcall(*output, na_id_compare, 1, *input_1)) < 0) {
	*output=*input_1;
}