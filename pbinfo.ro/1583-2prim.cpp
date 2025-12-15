#include <bits/stdc++.h>

using namespace std;

ifstream in("2prim.in");
ofstream out("2prim.out");

bool isPrime(int n) {
    if (n < 2) return 0;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}

int main() {
    int n;
    in >> n;

    int cnt = 0;
    while (n--) {
        int x;
        in >> x;
        cnt += isPrime(x % 100);
    }

    out << cnt;

    return 0;
}
