#include <bits/stdc++.h>

using namespace std;

ifstream in("bancomat.in");
ofstream out("bancomat.out");

int main() {
    int s, n;
    in >> s >> n;

    while (n--) {
        int x;
        in >> x;

        int c = x % 10;
        int sum = x / 10;

        if (c == 3) {
            if (s - sum >= 0) s -= sum;
        } else s += sum;
    }

    out << s;

    return 0;
}