char buf[24];

sprintf(buf, "%.8g", *input_1);

*output = rb_str_new2(buf);