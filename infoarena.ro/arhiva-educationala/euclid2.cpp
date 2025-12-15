#include <bits/stdc++.h>

using namespace std;

ifstream in("euclid2.in");
ofstream out("euclid2.out");

struct Ab {
    int a;
    int b;
};

int main() {
    int t;
    in >> t;

    while (t--) {
        int a, b;
        in >> a >> b;

        while (b) {
            int r = a % b;
            a = b;
            b = r;
        }
        out << a << "\n";
    }

    return 0;
}