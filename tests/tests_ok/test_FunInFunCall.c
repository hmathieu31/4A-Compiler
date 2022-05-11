
int fun(int x, int y) {
    int a = x;
    return a + y + 1; 
}

int foo(int x, int y) {
    int a = x;
    return a * y - 1;
}

main() {
    const int a = 3;
    int e = 4;
    int b = fun(2, 1);
    int d = foo(a,e);
    int d = fun(fun(a,e), foo(a,e)) + fun(3, 4) + fun(a,b) + fun(e,1);
    printf(d);
}