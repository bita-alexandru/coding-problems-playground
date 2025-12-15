#include <bits/stdc++.h>

using namespace std;

int main() {
    int t;
    cin >> t;

    while (t--) {
        int n;
        cin >> n;

        vector<int> a(n);
        for (auto& val: a) cin >> val;

        bool ok = true;
        for (int i = 0; i < n - 1; i++) {
            if (a[i] < 0) {
                ok = false;
                break;
            }

            if (a[i]) {
                a[i + 1] -= a[i];
                a[i] = 0;
            }
        }
        cout << ((ok && a.back() >= 0) ? "YES" : "NO") << "\n";
    }
    return 0;
}
