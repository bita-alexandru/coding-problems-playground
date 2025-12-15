#include <bits/stdc++.h>

using namespace std;

ifstream in("egal.in");
ofstream out("egal.out");

int main() {
    int n;
    in >> n;
// TODO: gresit
    vector<int> v(n);
    int m = 0;
    for (int i = 0; i < n; i++) {
        in >> v[i];
        m = max(m, v[i]);
    }

    long long sol = 0;
    for (int i = 0; i < n; i++) {
        sol += m - v[i];
        printf("%i from %i\n",sol,m - v[i]);
    }

    out << sol;

    return 0;
}
