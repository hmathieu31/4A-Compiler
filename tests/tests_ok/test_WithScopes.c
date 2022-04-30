
main() {
    int a = 3;
    int b = 4;
    if (a == 3 && b == 4)   // TODO: #34 Check why the memory used up in scopes is either not fred or not used up
    {
        int o = 5;
        while (a != 3) {
            int c = a;
            int d = b;
        }
    }
}
