#include <bits/stdc++.h>

using namespace std;

int main() {
    int t;
    cin >> t;

    while (t--) {
        int n, k;
        cin >> n >> k;

        int score = 0;
        multiset<int> ms;
        for (int i = 0; i < n; i++) {
            int x;
            cin >> x;
            int need = k - x;
            const auto& itNeed = ms.find(need);
            if (itNeed != ms.end()) {
                ms.erase(itNeed);
                score++;
            } else {
                ms.insert(x);
            }
        }

        cout << score << "\n";
    }
    return 0;
}
