#include <bits/stdc++.h>

using namespace std;

ifstream in("fazanr.in");
ofstream out("fazanr.out");

int main() {
    int n;
    in >> n;

    int prev = -1;
    int sol = 0;
    while (n--) {
        int x;
        in >> x;

        int u = x % 10;
        while (x > 9) x /= 10;

        if (prev != -1 && prev != x) {
            sol++;
        }
        prev = u;
    }

    out << sol;

    return 0;
}
