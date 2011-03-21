char buf[24];

sprintf(buf, "%.5g", *input_1);

*output = rb_str_new2(buf);