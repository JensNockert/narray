{
	char buf[24];
	
	sprintf(buf, "%g ", *input_1);
	 
	na_str_append_fp(buf);
	
	*output = rb_str_new2(buf);
}