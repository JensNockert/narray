{
	VALUE r = rb_funcall(**input_1, na_id_compare, 1, **input_2);
	
	return NUM2INT(r);
}