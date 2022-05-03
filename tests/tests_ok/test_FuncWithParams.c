
int fun(int x, int y) {
    int a = x;
    return a + y + 1;
}

main() {
    const int a = 3;
    int x;
    int b = fun(2, 1);
    int e = fun(a, b);
    printf(b);
}