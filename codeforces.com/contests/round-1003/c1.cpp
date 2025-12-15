#include <bits/stdc++.h>
// #define cin in
// #define cout out

using namespace std;

// ifstream in("input.txt");
// ofstream out("output.txt");

int main() {
    int t;
    cin >> t;

    while (t--) {
        int n, m;
        cin >> n >> m;

        vector<int> a(n);
        for (auto& val: a) cin >> val;
        int b;
        cin >> b;

        bool ok = true;
        for (int i = 0; i < n; i++) {
            a[i] = min(a[i], b - a[i]);
            if (i > 0) {
                if (a[i - 1] > a[i]) {
                    a[i] = max(a[i], b - a[i]);
                    if (a[i - 1] > a[i]) {
                        ok = false;
                        break;
                    }
                }
            }
        }

        cout << (ok ? "YES" : "NO") << "\n";
    }

    return 0;
}
