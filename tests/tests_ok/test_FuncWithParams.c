
int fun(int x, int y) {
    int a = x;
    return a + y + 1; 
}

main() {
    const int a = 3;
    int b = fun(2, 1);
    int d = fun(1, 2) + fun(3, 4) + fun(a,b) + fun(e,1);
    printf(d);
}