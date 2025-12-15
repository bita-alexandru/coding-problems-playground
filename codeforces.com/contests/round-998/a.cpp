#include <bits/stdc++.h>

using namespace std;

int main() {
    int t;
    cin >> t;

    while (t--) {
        int a1, a2, a4, a5;
        cin >> a1 >> a2 >> a4 >> a5;

        vector<int> v({a1 + a2, a4 - a2, a5 - a4});

        int max_cnt = 1;
        for (auto a3: v) {
            bitset<3> bits(false);
            bits[0] = bits[0] || (a3 == a1 + a2);
            bits[1] = bits[1] || (a4 == a2 + a3);
            bits[2] = bits[2] || (a5 == a3 + a4);

            max_cnt = max(max_cnt, (int) bits.count());
        }

        cout << max_cnt << "\n";
    }

    return 0;
}
