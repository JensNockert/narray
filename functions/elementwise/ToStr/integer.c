char buf[22];

sprintf(buf, "%i", *input_1);

*output = rb_str_new2(buf);
