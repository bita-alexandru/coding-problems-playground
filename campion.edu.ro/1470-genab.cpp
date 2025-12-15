#include <bits/stdc++.h>

using namespace std;

ifstream in("genab.in");
ofstream out("genab.out");

void bkt(int k, int n, string s, char prev) {
    if (k == n) {
        out << s << "\n";
        return;
    }

    bkt(k + 1, n, s + "a", 'a');
    if (prev != 'b') bkt(k + 1, n, s + "b", 'b');
}

int main() {
    int n;
    in >> n;

    bkt(0, n, string(), 'a');

    return 0;
}
