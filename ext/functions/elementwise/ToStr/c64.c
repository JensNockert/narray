char buf[50];

sprintf(buf, "%.8g%+.8gi", input_1->r, input_1->i);

*output = rb_str_new2(buf);