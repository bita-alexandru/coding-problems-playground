#include <bits/stdc++.h>
// #define cin in
// #define cout out

using namespace std;

// ifstream in("input.txt");
// ofstream out("output.txt");

int main() {
    cin.tie(nullptr)->sync_with_stdio(false);
    
    int t;
    cin >> t;

    while (t--) {
        int n, m;
        cin >> n >> m;

        vector<int> a(n);
        for (auto& val: a) cin >> val;
        vector<int> b(m);
        for (auto& val: b) cin >> val;
        sort(b.begin(), b.end());

        bool ok = true;
        a[0] = min(a[0], b.front() - a[0]);
        for (int i = 1; i < n && ok; i++) {
            int curr = min(a[i], b.front() - a[i]);

            if (a[i - 1] > curr) {
                auto lb = lower_bound(b.begin(), b.end(), -1, [&](const int& bj, const int& _) {
                    return a[i - 1] > bj - a[i];
                });

                if (lb == b.end()) {
                    if (a[i - 1] > a[i]) {
                        ok = false;
                        break;
                    } else curr = a[i];
                } else {
                    if (a[i - 1] > a[i]) {
                        curr = *lb - a[i];
                    } else {
                        curr = min(*lb - a[i], a[i]);
                    }
                }
            }
            
            a[i] = curr;
        }

        cout << (ok ? "YES" : "NO") << "\n";
    }

    return 0;
}
