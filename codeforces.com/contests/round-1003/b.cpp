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
        string s;
        cin >> s;

        bool ok = false;
        for (int i = 0; i < s.size() - 1; i++) {
            if (s[i] == s[i + 1]) {
                ok = true;
                break;
            }
        }

        if (s.size() == 1) cout << 1;
        else cout << (ok ? 1 : s.size());
        cout << "\n";
    }

    return 0;
}
