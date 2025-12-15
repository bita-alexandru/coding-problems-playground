#include <bits/stdc++.h>

using namespace std;

ifstream in("cmmdc.in");
ofstream out("cmmdc.out");

int cmmdc(int a, int b) {
    if (b == 0) {
        return a == 1 ? 0 : a;
    }
    return cmmdc(b, a % b);
}

int main() {
    int a, b;
    in >> a >> b;

    out <<  cmmdc(a, b);

    return 0;
}