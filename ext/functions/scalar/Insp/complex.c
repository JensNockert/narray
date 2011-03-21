{
	char buf[50], *b;
	
	sprintf(buf, "%g", input_1->r);
	
	na_str_append_fp(buf);
	
	b = buf + strlen(buf);
	
	sprintf(b, "%+g", input_1->i);
	
	na_str_append_fp(b);
	
	strcat(buf, "i");
	
	*output = rb_str_new2(buf);
}