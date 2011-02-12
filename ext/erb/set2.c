static void
<%=c_iterator%>(na_loop_t *const lp)
{
    size_t  i;
    char   *p1, *p2;
    ssize_t s1, s2;
    ssize_t *idx1, *idx2;
    dtype   x;
    <%=dtype%> y;
    INIT_COUNTER(lp, i);
    INIT_PTR(lp, 0, p1, s1, idx1);
    INIT_PTR(lp, 1, p2, s2, idx2);
    if (idx1||idx2) {
        for (; i--;) {
            LOAD_DATA_NOSTEP(p1, s1, idx1, dtype, x);
            LOAD_DATA_STEP(p2, s2, idx1, <%=dtype%>, y);
            x = m_<%=op%>(x,y);
            STORE_DATA_STEP(p2, s2, idx2, dtype, x);
        }
    } else {
        for (; i--;) {
            x = *(dtype*)p1;
            y = *(<%=dtype%>*)p2;
            x = m_<%=op%>(x,y);
            *(dtype*)p1 = x;
            p1+=s1;
            p2+=s2;
        }
    }
}

static VALUE
<%=c_instance_method%>(VALUE self, VALUE a1)
{
    ndfunc_t *func;
    VALUE v;
    func = ndfunc_alloc(<%=c_iterator%>, FULL_LOOP,
                        2, 0, cT, <%=tpclass%>);
    ndloop_do(func, 2, self, a1);
    ndfunc_free(func);
    return a1;
}
