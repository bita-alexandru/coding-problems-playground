#include <bits/stdc++.h>

using namespace std;

ifstream in("fractii.in");
ofstream out("fractii.out");

int main() {
    int n;
    in >> n;

    vector<int> phi(n + 1);
    iota(phi.begin(), phi.end(), 0);

    long long sol = 0;
    for (int i = 2; i <= n; i++) {
        if (phi[i] == i) {
            sol += i - 1;
            for (int j = i + i; j <= n; j += i) {
                phi[j] = phi[j] / i * (i - 1);
            }
        } else sol += phi[i];
    }

    out << 1 + sol * 2;

    return 0;
}